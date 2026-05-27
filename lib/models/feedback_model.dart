import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String id;
  final String ticketId;
  final String userId;
  final String userName;
  final String registration;
  final String mealType;
  final String dateKey;
  final int rating;
  final List<String> selectedTags;
  final String comment;
  final DateTime createdAt;

  const FeedbackModel({
    required this.id,
    required this.ticketId,
    required this.userId,
    required this.userName,
    required this.registration,
    required this.mealType,
    required this.dateKey,
    required this.rating,
    required this.selectedTags,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'ticketId': ticketId,
      'userId': userId,
      'userName': userName,
      'registration': registration,
      'mealType': mealType,
      'dateKey': dateKey,
      'rating': rating,
      'selectedTags': selectedTags,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory FeedbackModel.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    final createdAtValue = map['createdAt'];

    return FeedbackModel(
      id: id,
      ticketId: map['ticketId'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      registration: map['registration'] ?? '',
      mealType: map['mealType'] ?? '',
      dateKey: map['dateKey'] ?? '',
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      selectedTags: List<String>.from(map['selectedTags'] ?? []),
      comment: map['comment'] ?? '',
      createdAt: createdAtValue is Timestamp
          ? createdAtValue.toDate()
          : DateTime.now(),
    );
  }
}