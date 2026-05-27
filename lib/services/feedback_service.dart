import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/feedback_model.dart';
import '../models/ticket_model.dart';

class FeedbackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _feedbacks {
    return _firestore.collection('feedbacks');
  }

  Future<FeedbackModel?> getFeedbackByTicketId(String ticketId) async {
    final snapshot = await _feedbacks.doc(ticketId).get();

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return FeedbackModel.fromMap(
      id: snapshot.id,
      map: snapshot.data()!,
    );
  }

  Future<void> saveFeedback({
    required TicketModel ticket,
    required int rating,
    required List<String> selectedTags,
    required String comment,
  }) async {
    final existingFeedback = await getFeedbackByTicketId(ticket.id);

    if (existingFeedback != null) {
      throw Exception('Esta ficha já recebeu uma avaliação.');
    }

    if (ticket.status != 'validated') {
      throw Exception('Apenas fichas validadas podem ser avaliadas.');
    }

    if (rating < 1 || rating > 5) {
      throw Exception('A nota precisa estar entre 1 e 5.');
    }

    final feedback = FeedbackModel(
      id: ticket.id,
      ticketId: ticket.id,
      userId: ticket.userId,
      userName: ticket.userName,
      registration: ticket.registration,
      mealType: ticket.mealType,
      dateKey: ticket.dateKey,
      rating: rating,
      selectedTags: selectedTags,
      comment: comment.trim(),
      createdAt: DateTime.now(),
    );

    await _feedbacks.doc(ticket.id).set(feedback.toMap());
  }

  Stream<List<FeedbackModel>> watchTodayFeedbacks(String dateKey) {
    return _feedbacks.where('dateKey', isEqualTo: dateKey).snapshots().map(
      (snapshot) {
        final feedbacks = snapshot.docs.map((doc) {
          return FeedbackModel.fromMap(
            id: doc.id,
            map: doc.data(),
          );
        }).toList();

        feedbacks.sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
        );

        return feedbacks;
      },
    );
  }
}