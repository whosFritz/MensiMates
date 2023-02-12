import 'dish_class.dart';

class DishGroupCat {
  final String kategorie;
  final List<Dish> gerichteingruppe;
  bool isexpanded;

  DishGroupCat(
    this.kategorie,
    this.gerichteingruppe,
    this.isexpanded
  );

  @override
  String toString() {
    return "$kategorie-Gruppe: $gerichteingruppe";
  }
}
