import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

Future<void> searchGerichte(String query) async {
  final Uri url = Uri.parse('https://www.google.com/search?q=$query&tbm=isch');
  launchUrl(url, mode: LaunchMode.externalApplication);
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

Future<String?> getTokenFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwtToken');
}

Future<void> setTokenToSharedPreferences(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('jwtToken', token);
}

// Function to build the data URL for fetching dishes
String buildGetDataUrl(String mealsForFritzBaseLink) {
  DateTime currentDate = DateTime.now();
  DateTime dayInPast = currentDate.subtract(const Duration(days: 10));
  DateTime dayInFuture = currentDate.add(const Duration(days: 10));

  String dayInPastAsString = DateFormat('yyyy-MM-dd').format(dayInPast);
  String dayInFutureAsString = DateFormat("yyyy-MM-dd").format(dayInFuture);
  String getDataUrl =
      "$mealsForFritzBaseLink/getMeals/from/$dayInPastAsString/to/$dayInFutureAsString";

  return getDataUrl;
}

// Methode um Gerichte zu holen und umzuwandeln.
Future<List<Dish>> fetchDataWithJwtToken(Mensi mensiObj) async {
  String mealsForFritzBaseLink = decideMensi(mensiObj.id);

  String getDataUrl = buildGetDataUrl(mealsForFritzBaseLink);

  try {
    String? cookieToken = await getTokenFromSharedPreferences();
    if (cookieToken != null) {
      DateTime expirationDate = JwtDecoder.getExpirationDate(cookieToken);
      log("Expiration date: $expirationDate");
      log("Current date: ${DateTime.now()}");
      if (JwtDecoder.isExpired(cookieToken)) {
        // Token is expired
        log("Token is expired");
        log("old token: $cookieToken");
        return await fetchDishesFromApi(getDataUrl, await loginAndGetToken());
      } else {
        // Token is not expired
        log("Token is not expired");
        return await fetchDishesFromApi(getDataUrl, cookieToken);
      }
    }
    if (cookieToken == null) {
      return await fetchDishesFromApi(getDataUrl, await loginAndGetToken());
    }
  } catch (error) {
    log('Exception: $error');
  }

  return []; // Return an empty list if there is an error or no data
}

// Function to login and get JWT token
Future<String> loginAndGetToken() async {
  const user = apiUsername;
  const pw = password;
  String loginUrl = "https://api.olech2412.de/mensaHub/auth/login";
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
    String token = loginResponse.body;
    log("new Token: $token");
    return token;
  } else {
    log('Error when trying to Login: ${loginResponse.statusCode}');
    return '';
  }
}

// Function to fetch dishes from the API using the JWT token
Future<List<Dish>> fetchDishesFromApi(
    String getDataUrl, String localToken) async {
  final dataResponse = await http.get(
    Uri.parse(getDataUrl),
    headers: {
      'Authorization': 'Bearer $localToken',
    },
  );

  if (dataResponse.statusCode == 200) {
    setTokenToSharedPreferences(localToken);
    final jsonData = jsonDecode(utf8.decode(dataResponse.bodyBytes));
    List<Dish> listOfDishes = jsonData.map<Dish>(Dish.fromJson).toList();
    listOfDishes.sort((a, b) => a.servingDate.compareTo(b.servingDate));
    return listOfDishes;
  } else if (dataResponse.statusCode == 401) {
    log("401: Token abgelaufen oder nicht vorhanden");
    return fetchDishesFromApi(getDataUrl, await loginAndGetToken());
  } else {
    log('Error when trying to get Data: ${dataResponse.statusCode}');
    return [];
  }
}

Future<List<Dish>> getOfflineDishes() async {
  SharedPreferences offlineDishesGet = await SharedPreferences.getInstance();
  List<String>? listOfflineDishesStrings =
      offlineDishesGet.getStringList('offlineDishes');
  List<Dish> listOfflineDishes = [];
  for (String dishString in listOfflineDishesStrings!) {
    var decodedJson = jsonDecode(dishString);
    listOfflineDishes.add(Dish.fromJson(decodedJson));
  }
  /* for (String dishString in listOfDishStrings) {
      var decodedJson = jsonDecode(dishString);
      log(decodedJson);
    }
    */
  return listOfflineDishes;
}

void setOfflineDishes(List<Dish> dishesFromOle) async {
  SharedPreferences offlineDishesSet = await SharedPreferences.getInstance();
  List<Dish> currentDishList = dishesFromOle;
  List<String> listCurrentDishStrings = [];
  for (Dish dish in currentDishList) {
    listCurrentDishStrings.add(dish.toJson());
  }
  await offlineDishesSet.setStringList('offlineDishes', listCurrentDishStrings);
}

Future<List<int>> readListFromStorage() async {
  final prefs = await SharedPreferences.getInstance();
  List<String>? list = prefs.getStringList("ratedDishesInMemory");
  if (list == null) {
    return [];
  }

  List<int> intIdListe = [];
  for (String stringID in list) {
    intIdListe.add(int.parse(stringID));
  }
  return intIdListe;
}

Future<void> writeListToStorage(List<int> list) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setStringList(
      "ratedDishesInMemory", list.map((e) => e.toString()).toList());
}

Future<bool> sendRatingForMeal(double ratingValue, List<int> ratedDishesIDList,
    Dish dishObj, Mensi mensi) async {
  try {
    Dish dishToSend = Dish(
        id: dishObj.id,
        name: dishObj.name,
        description: dishObj.description,
        price: dishObj.price,
        category: dishObj.category,
        servingDate: dishObj.servingDate,
        additionalInfo: dishObj.additionalInfo,
        allergens: dishObj.allergens,
        additives: dishObj.additives,
        rating: ratingValue,
        votes: dishObj.votes);
    // Convert the Dish object to JSON
    String dishJsonToSend = dishToSend.toJson();
    String sendingToken = await loginAndGetToken();
    String cafeteriaMealsLink = decideMensi(mensi.id);
    final sendingResponse = await http.post(
      Uri.parse("$cafeteriaMealsLink/sendRating"),
      headers: {
        'Accept': '*/*',
        'Authorization': 'Bearer $sendingToken',
        'Content-Type': 'application/json',
      },
      body: dishJsonToSend,
    );

    if (sendingResponse.statusCode == 200) {
      // wenn senden erfolgreich
      log("Sending rating was successful");
      ratedDishesIDList.add(dishObj.id);
      // Then save dish to memory
      writeListToStorage(ratedDishesIDList);
      return true;
    } else {
      log('Error when trying to send Data: ${sendingResponse.statusCode}');
      return false;
    }
  } catch (error) {
    log('Exception: $error');
    return false;
  }
}

Color decideAppBarColor(String category) {
  Color appBarColor;
  if (category == "Vegetarisches Gericht") {
    appBarColor = const Color.fromARGB(255, 59, 215, 67);
  } else if (category == "Fleischgericht") {
    appBarColor = const Color.fromARGB(255, 244, 120, 32);
  } else if (category == "Veganes Gericht") {
    appBarColor = const Color.fromARGB(255, 138, 238, 143);
  } else if (category == "Pastateller") {
    appBarColor = const Color.fromRGBO(210, 180, 140, 1);
  } else if (category == "Fischgericht") {
    appBarColor = const Color.fromARGB(255, 52, 174, 236);
  } else {
    appBarColor = Colors.white;
  }
  return appBarColor;
}
