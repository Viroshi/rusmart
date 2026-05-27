import 'package:cloud_firestore/cloud_firestore.dart';

class MenuModel {
  final String id;
  final String dateKey;
  final String mainDish;
  final String sideDishes;
  final String vegetarianOption;
  final String dessert;
  final String drink;
  final String allergens;
  final String observations;
  final DateTime updatedAt;
  final String updatedBy;

  const MenuModel({
    required this.id,
    required this.dateKey,
    required this.mainDish,
    required this.sideDishes,
    required this.vegetarianOption,
    required this.dessert,
    required this.drink,
    required this.allergens,
    required this.observations,
    required this.updatedAt,
    required this.updatedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'dateKey': dateKey,
      'mainDish': mainDish,
      'sideDishes': sideDishes,
      'vegetarianOption': vegetarianOption,
      'dessert': dessert,
      'drink': drink,
      'allergens': allergens,
      'observations': observations,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'updatedBy': updatedBy,
    };
  }

  factory MenuModel.fromMap({
    required String id,
    required Map<String, dynamic> map,
  }) {
    final updatedAtValue = map['updatedAt'];

    return MenuModel(
      id: id,
      dateKey: map['dateKey'] ?? '',
      mainDish: map['mainDish'] ?? '',
      sideDishes: map['sideDishes'] ?? '',
      vegetarianOption: map['vegetarianOption'] ?? '',
      dessert: map['dessert'] ?? '',
      drink: map['drink'] ?? '',
      allergens: map['allergens'] ?? '',
      observations: map['observations'] ?? '',
      updatedAt: updatedAtValue is Timestamp
          ? updatedAtValue.toDate()
          : DateTime.now(),
      updatedBy: map['updatedBy'] ?? '',
    );
  }
}