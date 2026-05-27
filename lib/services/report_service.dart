import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/daily_report_model.dart';
import '../models/ticket_model.dart';

class ReportService {
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

  Stream<DailyReportModel> watchTodayReport() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateKey = dateKeyFromDate(today);

    return _tickets.where('dateKey', isEqualTo: dateKey).snapshots().map(
      (snapshot) {
        final tickets = snapshot.docs.map((doc) {
          return TicketModel.fromMap(
            id: doc.id,
            map: doc.data(),
          );
        }).toList();

        tickets.sort(
          (a, b) => a.queuePosition.compareTo(b.queuePosition),
        );

        return DailyReportModel(
          dateKey: dateKey,
          date: today,
          tickets: tickets,
        );
      },
    );
  }
}