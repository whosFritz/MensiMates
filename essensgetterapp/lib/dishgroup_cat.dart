import 'dish_class.dart';

class DishGroupCat {
  final String kategorie;
  final List<Dish> gerichteingruppe;

  DishGroupCat(this.kategorie, this.gerichteingruppe);

  @override
  String toString() {
    return "$kategorie-Gruppe: $gerichteingruppe";
  }
}
