import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users {
    return _firestore.collection('users');
  }

  Future<void> createStudentProfile({
    required String uid,
    required String name,
    required String email,
    required String registration,
  }) async {
    final AppUserModel user = AppUserModel(
      id: uid,
      name: name.trim(),
      email: email.trim(),
      registration: registration.trim(),
      role: 'student',
      createdAt: DateTime.now(),
    );

    await _users.doc(uid).set(user.toMap());
  }

  Future<void> createAdminProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    final AppUserModel user = AppUserModel(
      id: uid,
      name: name.trim(),
      email: email.trim(),
      registration: '',
      role: 'admin',
      createdAt: DateTime.now(),
    );

    await _users.doc(uid).set(user.toMap());
  }

  Future<AppUserModel?> getUserProfile(String uid) async {
    final snapshot = await _users.doc(uid).get();

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return AppUserModel.fromMap(
      id: snapshot.id,
      map: snapshot.data()!,
    );
  }

  Future<void> ensureStudentProfileExists({
    required String uid,
    required String email,
  }) async {
    final existingUser = await getUserProfile(uid);

    if (existingUser != null) {
      return;
    }

    await createStudentProfile(
      uid: uid,
      name: 'Estudante RU Smart',
      email: email,
      registration: '2024000000',
    );
  }

  Stream<AppUserModel?> watchUserProfile(String uid) {
    return _users.doc(uid).snapshots().map(
      (snapshot) {
        if (!snapshot.exists || snapshot.data() == null) {
          return null;
        }

        return AppUserModel.fromMap(
          id: snapshot.id,
          map: snapshot.data()!,
        );
      },
    );
  }

  Future<bool> isAdmin(String uid) async {
    final user = await getUserProfile(uid);

    return user?.role == 'admin';
  }

  Future<bool> isStudent(String uid) async {
    final user = await getUserProfile(uid);

    return user?.role == 'student';
  }
}
