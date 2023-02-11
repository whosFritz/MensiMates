import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dish_class.dart';

  Future<List<Dish>> getofflineDishes() async {
    SharedPreferences offlineDishesget = await SharedPreferences.getInstance();
    List<String>? listOfofflineDishStrings =
        offlineDishesget.getStringList('oofflineDishes');
    /* List<String> listOfofflineDishStringss = [
      '{"id":8435984382,"name":"Rucola-Süßkartoffel Schnitte","servingDate":"2023-02-07","category":"Veganes Gericht","price":"2,40€/ 4,00€/ 5,50€","description":"Chili-Tomatensoße, Rosmarinkartoffeln, glutenhaltiges Getreide, Weizen, Gerste, Veganes Gericht, Konservierungsstoff","rating":2.0,"responseCode":200,"votes":1}',
      '{"id":8435984396,"name":"Kartoffel-Pfanne mit Champignon, Wirsing & Erdnusscreme","servingDate":"2023-02-07","category":"Veganes Gericht","price":"2,40€/ 4,00€/ 5,50€","description":"Erdnüsse, Soja, Veganes Gericht","rating":0.0,"responseCode":200,"votes":0}'
    ]; 
    */
    List<Dish> listOfofflineDishes = [];
    for (String dishString in listOfofflineDishStrings!) {
      var decodedJson = jsonDecode(dishString);
      listOfofflineDishes.add(Dish.fromJson(decodedJson));
    }
    /* for (String dishString in listOfDishStringss) {
      var decodedJson = jsonDecode(dishString);
      print(decodedJson);
    }
    */
    return listOfofflineDishes;
  }

  void setofflineDishes(List<Dish> dishesfromOle) async {
    SharedPreferences offlineDishesset = await SharedPreferences.getInstance();
    List<Dish> listcurrentDishes = dishesfromOle;
    List<String> listOfcurrentDishStrings = [];
    for (Dish dish in listcurrentDishes) {
      listOfcurrentDishStrings.add(dish.toJson());
    }
    await offlineDishesset.setStringList(
        'offlineDishes', listOfcurrentDishStrings);
  }
