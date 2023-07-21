import "dart:convert";
import 'dart:developer';
import "package:mensimates/api/pw_and_username.dart";
import "package:flutter/material.dart";
import "package:flutter_rating_bar/flutter_rating_bar.dart";
import "package:intl/intl.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:http/http.dart" as http;
import '../entities/dish_class.dart';
import '../api/api_links.dart';
import '../entities/mensi_class.dart';
import "../utils/methods.dart";
import 'mensi_schedule.dart';

class DetailRatingPage extends StatefulWidget {
  final Dish dishdetailed;
  final Mensi mensiObjForDetailPage;

  const DetailRatingPage(
      {Key? key,
      required this.dishdetailed,
      required this.mensiObjForDetailPage})
      : super(key: key);

  @override
  State<DetailRatingPage> createState() => _DetailRatingPageState();
}

class _DetailRatingPageState extends State<DetailRatingPage> {
  // Variablen
  Map<String, double> mapRatingValues = {};
  String pageName = "Detailansicht";
  // TODO: look other todo and get dishes from initstate

  @override
  void initState() {
    super.initState();
    // TODO: "getting list from memory"
  }

  final String webPageTitle = "Bewertung abgeben";

  @override
  Widget build(BuildContext context) {
    if (DateFormat("yyyy-MM-dd").format(widget.dishdetailed.servingDate) ==
        DateFormat("yyy-MM-dd").format(DateTime.now())) {
      return Title(
        color: Colors.black,
        title: webPageTitle,
        child: Scaffold(
          appBar: AppBar(
            title: Text(pageName),
            backgroundColor: decideAppBarColor(widget.dishdetailed.category),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.blueGrey,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: GestureDetector(
              child: Column(children: [
                Container(
                    color: decideContainerColor(widget.dishdetailed.category),
                    child: MensiScheduleState.buildDishBox(
                        context, widget.dishdetailed)),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Geschmack",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontFamily: "Open Sans",
                                      fontSize: 20,
                                      color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RatingBar.builder(
                              onRatingUpdate: (newValue) {
                                setState(() {
                                  mapRatingValues["taste"] = newValue;
                                });
                              },
                              itemBuilder: (context, index) => const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFA9C00),
                              ),
                              direction: Axis.horizontal,
                              initialRating: 0,
                              unratedColor: const Color(0xFF9E9E9E),
                              itemCount: 5,
                              itemSize: 40,
                              glowColor: const Color(0xFFFA9C00),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Aussehen",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontFamily: "Open Sans",
                                      fontSize: 20,
                                      color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RatingBar.builder(
                              onRatingUpdate: (newValue) {
                                setState(() {
                                  mapRatingValues["look"] = newValue;
                                });
                              },
                              itemBuilder: (context, index) => const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFA9C00),
                              ),
                              direction: Axis.horizontal,
                              initialRating: 0,
                              unratedColor: const Color(0xFF9E9E9E),
                              itemCount: 5,
                              itemSize: 40,
                              glowColor: const Color(0xFFFA9C00),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Preis-Leistung",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontFamily: "Open Sans",
                                      fontSize: 20,
                                      color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RatingBar.builder(
                              onRatingUpdate: (newValue) {
                                setState(() {
                                  mapRatingValues["price"] = newValue;
                                });
                              },
                              itemBuilder: (context, index) => const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFA9C00),
                              ),
                              direction: Axis.horizontal,
                              initialRating: 0,
                              unratedColor: const Color(0xFF9E9E9E),
                              itemCount: 5,
                              itemSize: 40,
                              glowColor: const Color(0xFFFA9C00),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFFFA9C00)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)))),
                                onPressed: () {
                                  Dish dishObj = widget.dishdetailed;
                                  readListFromStorage()
                                      .then((List<int> ratedDishesIDList) {
                                    if (ratedDishesIDList
                                        .contains(dishObj.id)) {
                                      // Restrict User from rating cause already voted
                                      showSnackBar2(context);
                                    } else {
                                      int mapLenght = mapRatingValues.length;
                                      if (mapLenght == 3) {
                                        // let User rate
                                        double sum = mapRatingValues.values
                                            .reduce((value, element) {
                                          return value + element;
                                        });
                                        double ratingValue =
                                            sum / mapRatingValues.length;
                                        sendRatingForMeal(ratingValue,
                                                ratedDishesIDList, dishObj)
                                            .then((bool sendingWasSuccessful) {
                                          if (sendingWasSuccessful) {
                                            showSnackBar1(context);
                                          } else {
                                            showSnackbar4(context);
                                          }
                                        });
                                      } else {
                                        // Restrict user cause not rated everything
                                        showSnackbar3(context);
                                      }
                                    }
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      30, 5, 30, 5),
                                  child: Text("Bewerten",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "Open Sans",
                                          fontSize: 20)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      );
    } else {
      return Title(
        color: Colors.black,
        title: webPageTitle,
        child: Scaffold(
          appBar: AppBar(
            title: Text(pageName),
            backgroundColor: decideAppBarColor(widget.dishdetailed.category),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.blueGrey,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: GestureDetector(
              child: Column(
                children: [
                  Container(
                    color: decideContainerColor(widget.dishdetailed.category),
                    child: Container(
                        color:
                            decideContainerColor(widget.dishdetailed.category),
                        child: MensiScheduleState.buildDishBox(
                            context, widget.dishdetailed)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(20, 5, 20, 5),
                        child: Text(
                          "Du kannst nur für den heutigen Tag abstimmen.",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontFamily: "Open Sans", fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  void showSnackBar1(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("👍 Bewertung abgegeben"),
        backgroundColor: Colors.blueGrey,
        elevation: 6,
        duration: Duration(seconds: 2)));
  }

  void showSnackBar2(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Dieses Gericht hast du schon bewertet. 🙃"),
        backgroundColor: Colors.blueGrey,
        elevation: 6,
        duration: Duration(seconds: 2)));
  }

  void showSnackbar3(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Bitte Bewertung vollständig ausfüllen."),
        backgroundColor: Colors.blueGrey,
        elevation: 6,
        duration: Duration(seconds: 2)));
  }

  void showSnackbar4(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text("Es konnte keine Verbindung zum Server hergestellt werden."),
        backgroundColor: Colors.blueGrey,
        elevation: 6,
        duration: Duration(seconds: 2)));
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

  Future<bool> sendRatingForMeal(
      double ratingValue, List<int> ratedDishesIDList, Dish dishObj) async {
    const loginUrl = "https://api.olech2412.de/mensaHub/auth/login";
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
        Dish dishToSend = Dish(
            id: dishObj.id,
            name: dishObj.name,
            description: dishObj.description,
            price: dishObj.price,
            category: dishObj.category,
            servingDate: dishObj.servingDate,
            responseCode: dishObj.responseCode,
            rating: ratingValue,
            votes: dishObj.votes);
        // Convert the Dish object to JSON
        String dishJsonToSend = dishToSend.toJson();

        final sendingToken = loginResponse.body;
        String cafeteriaMealsLink =
            decideMensi(widget.mensiObjForDetailPage.id);
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
      } else {
        log('Error when trying to Login: ${loginResponse.statusCode}');
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
}
