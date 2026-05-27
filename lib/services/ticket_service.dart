import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user_model.dart';
import '../models/ticket_model.dart';

class TicketService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _tickets {
    return _firestore.collection('tickets');
  }

  String todayDateKey() {
    return dateKeyFromDate(DateTime.now());
  }

  String dateKeyFromDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Future<TicketModel?> getTodayTicket(String userId) async {
    final snapshot = await _tickets
        .where('userId', isEqualTo: userId)
        .where('dateKey', isEqualTo: todayDateKey())
        .get();

    final tickets = snapshot.docs.map((doc) {
      return TicketModel.fromMap(
        id: doc.id,
        map: doc.data(),
      );
    }).where((ticket) {
      return ticket.status == 'paid' || ticket.status == 'validated';
    }).toList();

    tickets.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );

    return tickets.isEmpty ? null : tickets.first;
  }

  Stream<TicketModel?> watchTodayTicket(String userId) {
    return _tickets
        .where('userId', isEqualTo: userId)
        .where('dateKey', isEqualTo: todayDateKey())
        .snapshots()
        .map((snapshot) {
      final tickets = snapshot.docs.map((doc) {
        return TicketModel.fromMap(
          id: doc.id,
          map: doc.data(),
        );
      }).where((ticket) {
        return ticket.status == 'paid' || ticket.status == 'validated';
      }).toList();

      tickets.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );

      return tickets.isEmpty ? null : tickets.first;
    });
  }

  Stream<TicketModel?> watchTicketById(String ticketId) {
    return _tickets.doc(ticketId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }

      return TicketModel.fromMap(
        id: snapshot.id,
        map: snapshot.data()!,
      );
    });
  }

  Stream<List<TicketModel>> watchTodayPaidTickets() {
    return _tickets
        .where('dateKey', isEqualTo: todayDateKey())
        .where('status', isEqualTo: 'paid')
        .snapshots()
        .map((snapshot) {
      final tickets = snapshot.docs.map((doc) {
        return TicketModel.fromMap(
          id: doc.id,
          map: doc.data(),
        );
      }).toList();

      tickets.sort(
        (a, b) => a.queuePosition.compareTo(b.queuePosition),
      );

      return tickets;
    });
  }

  Future<TicketModel> createPaidTicket({
    required AppUserModel user,
    String mealType = 'Almoço',
    double price = 3.00,
  }) async {
    final existingTicket = await getTodayTicket(user.id);

    if (existingTicket != null) {
      return existingTicket;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateKey = dateKeyFromDate(today);

    final todayTicketsSnapshot = await _tickets
        .where('dateKey', isEqualTo: dateKey)
        .get();

    final queuePosition = todayTicketsSnapshot.docs.length + 1;
    final window = _calculateSuggestedWindow(queuePosition);

    // O ID fixo por aluno e data evita duas fichas ativas no mesmo dia.
    final docRef = _tickets.doc('${dateKey}_${user.id}');
    final qrCode = 'RU_SMART|$dateKey|${user.id}|${docRef.id}';

    final ticket = TicketModel(
      id: docRef.id,
      userId: user.id,
      userName: user.name,
      userEmail: user.email,
      registration: user.registration,
      dateKey: dateKey,
      date: today,
      mealType: mealType,
      price: price,
      status: 'paid',
      qrCode: qrCode,
      queuePosition: queuePosition,
      suggestedStartTime: window['start']!,
      suggestedEndTime: window['end']!,
      createdAt: now,
    );

    await docRef.set(ticket.toMap());

    return ticket;
  }

  Future<TicketModel?> findTicketByQrCode(String qrCode) async {
    final snapshot = await _tickets
        .where('qrCode', isEqualTo: qrCode.trim())
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc = snapshot.docs.first;

    return TicketModel.fromMap(
      id: doc.id,
      map: doc.data(),
    );
  }

  Future<TicketModel?> getTicketById(String ticketId) async {
    final snapshot = await _tickets.doc(ticketId).get();

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return TicketModel.fromMap(
      id: snapshot.id,
      map: snapshot.data()!,
    );
  }

  Future<TicketModel> validateTicketByQrCode({
    required String qrCode,
  }) async {
    final ticket = await findTicketByQrCode(qrCode);

    if (ticket == null) {
      throw Exception('Ficha não encontrada.');
    }

    await _validateTicket(ticket);

    return ticket;
  }

  Future<TicketModel> validateTicketById({
    required String ticketId,
  }) async {
    final ticket = await getTicketById(ticketId);

    if (ticket == null) {
      throw Exception('Ficha não encontrada.');
    }

    await _validateTicket(ticket);

    return ticket;
  }

  Future<void> _validateTicket(TicketModel ticket) async {
    if (ticket.dateKey != todayDateKey()) {
      throw Exception('Esta ficha não pertence ao dia de hoje.');
    }

    if (ticket.status == 'validated') {
      throw Exception('Esta ficha já foi validada.');
    }

    if (ticket.status != 'paid') {
      throw Exception('Esta ficha não está ativa para validação.');
    }

    await _tickets.doc(ticket.id).update({
      'status': 'validated',
      'validatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Map<String, String> _calculateSuggestedWindow(int queuePosition) {
    const int studentsPerWindow = 20;
    const int minutesPerWindow = 10;

    final int group = (queuePosition - 1) ~/ studentsPerWindow;

    final DateTime now = DateTime.now();
    final DateTime baseTime = DateTime(
      now.year,
      now.month,
      now.day,
      12,
      0,
    );

    final DateTime start = baseTime.add(
      Duration(minutes: group * minutesPerWindow),
    );

    final DateTime end = start.add(
      const Duration(minutes: minutesPerWindow),
    );

    return {
      'start': _formatTime(start),
      'end': _formatTime(end),
    };
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
