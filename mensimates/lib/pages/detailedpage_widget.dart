import "dart:convert";
import "dart:developer";

import "package:flutter/material.dart";
import "package:flutter_rating_bar/flutter_rating_bar.dart";
import 'package:http/http.dart' as http;
import "package:intl/intl.dart";
import "package:jwt_decoder/jwt_decoder.dart";
import "package:mensimates/api/api_links.dart";

import '../entities/dish_class.dart';
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
  double ratingValue = 0.0;

  // TODO: look other todo and get dishes from initState

  @override
  void initState() {
    super.initState();
    // TODO: "getting list from memory"
  }

  final String webPageTitle = "Bewertung abgeben";

  double calculateRating(Map<String, double> mapRatingValues) {
    double sum = 0;
    for (double rating in mapRatingValues.values) {
      sum += rating;
    }
    double ratingValue = sum / mapRatingValues.length;
    double roundedRatingValue = double.parse(ratingValue.toStringAsFixed(2));
    setState(() {
      ratingValue = roundedRatingValue;
    });
    return roundedRatingValue;
  }

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
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                    color: decideContainerColor(widget.dishdetailed.category),
                    child: MensiScheduleState.buildDishBox(
                        context, widget.dishdetailed)),
                Padding(
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
                                ratingValue = calculateRating(mapRatingValues);
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
                                ratingValue = calculateRating(mapRatingValues);
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
                                ratingValue = calculateRating(mapRatingValues);
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("Dein Rating ist: $ratingValue")],
                        ),
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
                                  if (ratedDishesIDList.contains(dishObj.id)) {
                                    // Restrict User from rating cause already voted
                                    showSnackBar2(context);
                                  } else {
                                    if (mapRatingValues.length == 3) {
                                      // let User rate
                                      ratingValue =
                                          calculateRating(mapRatingValues);
                                      sendRatingForMeal(
                                              ratingValue,
                                              ratedDishesIDList,
                                              dishObj,
                                              widget.mensiObjForDetailPage)
                                          .then((bool sendingWasSuccessful) {
                                        if (sendingWasSuccessful) {
                                          showSnackBar1(context);
                                          updateDishInfo(widget.dishdetailed,
                                              widget.mensiObjForDetailPage);
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
            child: SingleChildScrollView(
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

  Future<List<Dish>> fetchByServingDate(String oneDishUrl, String token) async {
    final dataResponse = await http.get(
      Uri.parse(oneDishUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (dataResponse.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(dataResponse.bodyBytes));
      List<Dish> fetchedDishes = jsonData.map<Dish>(Dish.fromJson).toList();
      setTokenToSharedPreferences(token);
      return fetchedDishes;
    } else if (dataResponse.statusCode == 401) {
      log("401: Token abgelaufen oder nicht vorhanden");
      return fetchByServingDate(oneDishUrl, await loginAndGetToken());
    } else {
      log('Error when trying to get Data: ${dataResponse.statusCode}');
      throw Exception('Failed to load Data');
    }
  }

  Future<void> updateDishInfo(Dish localDish, Mensi localMensi) async {
    String baseUrlMensi = decideMensi(localMensi.id);
    String shortedDate = DateFormat("yyyy-MM-dd").format(localDish.servingDate);
    String oneDishUrl = "$baseUrlMensi/servingDate/$shortedDate";
    List<Dish> updatedDishes = [];
    Dish votedDish;
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
          updatedDishes =
              await fetchByServingDate(oneDishUrl, await loginAndGetToken());
        } else {
          // Token is not expired
          log("Token is not expired");
          updatedDishes = await fetchByServingDate(oneDishUrl, cookieToken);
        }
      }
      // Token is null probably because it is the first time the user is using the app
      if (cookieToken == null) {
        updatedDishes =
            await fetchByServingDate(oneDishUrl, await loginAndGetToken());
      }
      votedDish =
          updatedDishes.firstWhere((dish) => dish.name == localDish.name);
      setState(() {
        widget.dishdetailed.rating = votedDish.rating;
        widget.dishdetailed.votes = votedDish.votes;
      });
    } catch (error) {
      log('Exception: $error');
    }
  }
}
