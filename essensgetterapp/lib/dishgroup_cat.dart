import 'dish_class.dart';

class DishGroupCat {
  final String kategorie;
  final List<Dish> gerichteingruppe;
  bool isexpanded;
  int anzahlgerichte;

  DishGroupCat(
      {required this.kategorie,
      required this.gerichteingruppe,
      required this.isexpanded,
      this.anzahlgerichte = 0});

  @override
  String toString() {
    return "$kategorie-Gruppe: $gerichteingruppe";
  }
}
