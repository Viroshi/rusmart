import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/menu_model.dart';

class MenuService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _menus {
    return _firestore.collection('menus');
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

  Stream<MenuModel?> watchTodayMenu() {
    final dateKey = todayDateKey();

    return _menus.doc(dateKey).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }

      return MenuModel.fromMap(
        id: snapshot.id,
        map: snapshot.data()!,
      );
    });
  }

  Future<MenuModel?> getTodayMenu() async {
    final dateKey = todayDateKey();
    final snapshot = await _menus.doc(dateKey).get();

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return MenuModel.fromMap(
      id: snapshot.id,
      map: snapshot.data()!,
    );
  }

  Future<void> saveTodayMenu({
    required String mainDish,
    required String sideDishes,
    required String vegetarianOption,
    required String dessert,
    required String drink,
    required String allergens,
    required String observations,
    required String updatedBy,
  }) async {
    final dateKey = todayDateKey();

    final menu = MenuModel(
      id: dateKey,
      dateKey: dateKey,
      mainDish: mainDish.trim(),
      sideDishes: sideDishes.trim(),
      vegetarianOption: vegetarianOption.trim(),
      dessert: dessert.trim(),
      drink: drink.trim(),
      allergens: allergens.trim(),
      observations: observations.trim(),
      updatedAt: DateTime.now(),
      updatedBy: updatedBy,
    );

    await _menus.doc(dateKey).set(menu.toMap());
  }
}