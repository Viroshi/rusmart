import 'package:cloud_firestore/cloud_firestore.dart';

class AppUserModel {
  final String id;
  final String name;
  final String email;
  final String registration;
  final String role;
  final DateTime createdAt;

  const AppUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.registration,
    required this.role,
    required this.createdAt,
  });

  bool get isStudent => role == 'student';
  bool get isAdmin => role == 'admin';

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'registration': registration,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory AppUserModel.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    final dynamic createdAtValue = map['createdAt'];

    return AppUserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      registration: map['registration'] ?? '',
      role: map['role'] ?? 'student',
      createdAt: createdAtValue is Timestamp
          ? createdAtValue.toDate()
          : DateTime.now(),
    );
  }
}