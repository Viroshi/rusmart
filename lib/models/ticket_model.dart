import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String registration;
  final String dateKey;
  final DateTime date;
  final String mealType;
  final double price;
  final String status;
  final String qrCode;
  final int queuePosition;
  final String suggestedStartTime;
  final String suggestedEndTime;
  final DateTime createdAt;
  final DateTime? validatedAt;

  const TicketModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.registration,
    required this.dateKey,
    required this.date,
    required this.mealType,
    required this.price,
    required this.status,
    required this.qrCode,
    required this.queuePosition,
    required this.suggestedStartTime,
    required this.suggestedEndTime,
    required this.createdAt,
    this.validatedAt,
  });

  bool get isPaid => status == 'paid';
  bool get isValidated => status == 'validated';
  bool get isExpired => status == 'expired';

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'registration': registration,
      'dateKey': dateKey,
      'date': Timestamp.fromDate(date),
      'mealType': mealType,
      'price': price,
      'status': status,
      'qrCode': qrCode,
      'queuePosition': queuePosition,
      'suggestedStartTime': suggestedStartTime,
      'suggestedEndTime': suggestedEndTime,
      'createdAt': Timestamp.fromDate(createdAt),
      'validatedAt':
          validatedAt == null ? null : Timestamp.fromDate(validatedAt!),
    };
  }

  factory TicketModel.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    final dateValue = map['date'];
    final createdAtValue = map['createdAt'];
    final validatedAtValue = map['validatedAt'];

    return TicketModel(
      id: id,
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userEmail: map['userEmail'] ?? '',
      registration: map['registration'] ?? '',
      dateKey: map['dateKey'] ?? '',
      date: dateValue is Timestamp ? dateValue.toDate() : DateTime.now(),
      mealType: map['mealType'] ?? 'Almoço',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? 'paid',
      qrCode: map['qrCode'] ?? '',
      queuePosition: (map['queuePosition'] as num?)?.toInt() ?? 0,
      suggestedStartTime: map['suggestedStartTime'] ?? '',
      suggestedEndTime: map['suggestedEndTime'] ?? '',
      createdAt: createdAtValue is Timestamp
          ? createdAtValue.toDate()
          : DateTime.now(),
      validatedAt: validatedAtValue is Timestamp
          ? validatedAtValue.toDate()
          : null,
    );
  }
}