// Methode um Gerichte zu holen und umzuwandeln.
import 'package:flutter/material.dart';
import 'detailedpage_widget.dart';
import 'dish_class.dart';
import 'dishgroup.dart';
/*
  // Methode um Gerichte nach Datum zu filtern
  Future<List<Dish>> filterDishes() async {
    final dishes = await dishesfromOle;
    return dishes.where((dish) {
      return dish.servingDate == anzeigeDatum;
    }).toList();
  }
  */

//Navigation zur Detailpage
void navigateToDetailRatingPage(BuildContext context, Dish dishdetailed) {
  Navigator.of(context).push(
    MaterialPageRoute(
        builder: (context) {
          return DetailRatingPage(
            dishdetailed: dishdetailed,
          );
        },
        fullscreenDialog: true),
  );
}

/*
  Future<void> changeAnzeigeDatum(DateTime gruppendatum) async {
    await Future.delayed(
        const Duration(seconds: 1)); // wait for 100 millisecond

    setState(() {
      anzeigeDatum = gruppendatum;
    });
  }
  */

List<DishGroup> groupByDate(List<Dish> dishes) {
  final groups = <DateTime, DishGroup>{};
  for (final dish in dishes) {
    final date = dish.servingDate;
    if (!groups.containsKey(date)) {
      groups[date] = DishGroup(date, []);
    }
    groups[date]!.dishes.add(dish);
  }
  return groups.values.toList();
}
