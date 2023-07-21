import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api_links.dart';
import '../api/pw_and_username.dart';
import '../entities/dish_class.dart';
import '../entities/mensi_class.dart';
import '../pages/detailedpage_widget.dart';

Image decideIconFile(String iconMealType) {
  Image icon;
  switch (iconMealType) {
    case "Vegetarisches Gericht":
      icon = Image.asset("assets/images/vegetarian-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "Fleischgericht":
      icon = Image.asset("assets/images/meat-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "Fischgericht":
      icon = Image.asset("assets/images/fish-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "Veganes Gericht":
      icon = Image.asset("assets/images/vegan-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "Pastateller":
      icon = Image.asset("assets/images/pasta-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "Dessert":
      icon = Image.asset("assets/images/dessert-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "Smoothie":
      icon = Image.asset("assets/images/smoothie3-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "WOK":
      icon = Image.asset("assets/images/wok-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "Salat":
      icon = Image.asset("assets/images/salat-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "Gemüsebeilage":
      icon = Image.asset("assets/images/gemuesebeilage-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "Sättigungsbeilage":
      icon = Image.asset("assets/images/saettigungsbeilage-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "Schneller Teller":
      icon = Image.asset("assets/images/schneller-teller-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "Hauptkomponente":
      icon = Image.asset("assets/images/hauptkomponente-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "Grill":
      icon = Image.asset("assets/images/grill-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "Pizza":
      icon = Image.asset("assets/images/pizza-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "Suppe / Eintopf":
      icon = Image.asset("assets/images/suppe-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "mensaVital":
      icon = Image.asset("assets/images/mensaVital-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    case "Aktion":
      icon = Image.asset("assets/images/aktion-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
    default:
      icon = Image.asset("assets/images/default-icon.png",
          width: 40, fit: BoxFit.scaleDown);
      break;
  }
  return icon;
}

Color decideContainerColor(String category) {
  Color colors;
  switch (category) {
    case "Vegetarisches Gericht":
      colors = const Color.fromARGB(255, 52, 187, 58);
      break;
    case "Fleischgericht":
      colors = const Color.fromARGB(255, 220, 102, 13);
      break;
    case "Veganes Gericht":
      colors = const Color.fromARGB(255, 125, 213, 130);
      break;
    case "Pastateller":
      colors = const Color.fromARGB(255, 209, 177, 134);
      break;
    case "Fischgericht":
      colors = const Color.fromARGB(255, 37, 169, 235);
      break;
    case "Dessert":
      colors = const Color.fromARGB(255, 134, 107, 230);
      break;
    case "Smoothie":
      colors = const Color.fromARGB(255, 230, 121, 175);
      break;
    case "WOK":
      colors = const Color.fromARGB(255, 211, 183, 58);
      break;
    case "Salat":
      colors = const Color.fromARGB(255, 67, 185, 77);
      break;
    case "Gemüsebeilage":
      colors = const Color.fromARGB(255, 118, 199, 42);
      break;
    case "Sättigungsbeilage":
      colors = const Color.fromARGB(255, 235, 219, 80);
      break;
    case "Schneller Teller":
      colors = const Color.fromARGB(255, 66, 202, 161);
      break;
    case "Hauptkomponente":
      colors = const Color.fromARGB(255, 41, 218, 224);
      break;
    case "Grill":
      colors = const Color.fromARGB(255, 255, 178, 62);
      break;
    case "Pizza":
      colors = const Color.fromARGB(255, 243, 208, 111);
      break;
    case "Suppe / Eintopf":
      colors = const Color.fromARGB(255, 154, 202, 66);
      break;
    case "mensaVital":
      colors = const Color.fromARGB(255, 99, 209, 8);
      break;
    case "Aktion":
      colors = const Color.fromARGB(255, 221, 69, 120);
      break;
    default:
      colors = Colors.white;
      break;
  }
  return colors;
}

void searchGerichte(String query) async {
  final url = 'https://www.google.com/search?q=$query&tbm=isch';
  launchUrl(Uri.parse(url));
}

//Navigation zur Detail page
void navigateToDetailRatingPage(
    BuildContext context, Dish dishdetailed, Mensi mensiObj) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) {
      return DetailRatingPage(
        dishdetailed: dishdetailed,
        mensiObjForDetailPage: mensiObj,
      );
    },
  ));
} // Methode um Gerichte zu holen und umzuwandeln.

Future<List<Dish>> fetchDataWithJwtToken(Mensi mensiObj) async {
  DateTime currentDate = DateTime.now();
  DateTime dayInPast = currentDate.subtract(const Duration(days: 10));
  DateTime dayInFuture = currentDate.add(const Duration(days: 10));

  // Formatting the date as "yyyy-MM-dd"
  String dayInPastAsString = DateFormat('yyyy-MM-dd').format(dayInPast);
  String dayInFutureAsString = DateFormat("yyyy-MM-dd").format(dayInFuture);
  String mealsForFritzBaseLink = decideMensi(mensiObj.id);
  const loginUrl = "https://api.olech2412.de/mensaHub/auth/login";
  final getDataUrl =
      "$mealsForFritzBaseLink/getMeals/from/$dayInPastAsString/to/$dayInFutureAsString";
  const user = apiUsername;
  const pw = password;

  try {
    final loginResponse = await http
        .post(Uri.parse(loginUrl),
            headers: {
              'Accept': '*/*',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'apiUsername': user,
              'password': pw,
            }))
        .timeout(const Duration(seconds: 10));

    if (loginResponse.statusCode == 200) {
      final token = loginResponse.body;
      log('JWT Token: $token');

      final dataResponse = await http.get(
        Uri.parse(getDataUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (dataResponse.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(dataResponse.bodyBytes));
        List<Dish> listOfDishes = jsonData.map<Dish>(Dish.fromJson).toList();
        listOfDishes.sort((a, b) => a.servingDate.compareTo(b.servingDate));
        return listOfDishes; // Return the list of dishes
      } else {
        log('Error when trying to get Data: ${dataResponse.statusCode}');
      }
    } else {
      log('Error when trying to Login: ${loginResponse.statusCode}');
    }
  } catch (error) {
    log('Exception: $error');
  }

  return []; // Return an empty list if there is an error or no data
}
