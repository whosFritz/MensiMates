import 'dish_class.dart';

class DishGroupDate {
  final DateTime date;
  final List<Dish> gerichteingruppe;

  DishGroupDate(this.date, this.gerichteingruppe);

  @override
  String toString() {
    return "Diese Gruppen hat als gemeinsames Datum $date und die Items: $gerichteingruppe";
  }
}
