import "package:flutter/material.dart";
import "package:flutter_rating_bar/flutter_rating_bar.dart";
import "package:intl/intl.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:http/http.dart" as http;
import "dish_class.dart";
import "api_links.dart";
import "package:flutter_neumorphic/flutter_neumorphic.dart";
import 'mensi_schedule.dart';

class DetailRatingPage extends StatefulWidget {
  final Dish dishdetailed;
  final int mensiID;

  const DetailRatingPage(
      {Key? key, required this.dishdetailed, required this.mensiID})
      : super(key: key);

  @override
  State<DetailRatingPage> createState() => _DetailRatingPageState();
}

class _DetailRatingPageState extends State<DetailRatingPage> {
  // Variablen
  Map<String, double> mapratingvalues = {};
  String pagename = "Detailansicht";
  // TODO: look other todo and get dishes from initstae

  @override
  void initState() {
    super.initState();
    // TODO: "getting list from memory"
  }

  Future<void> showSnackBar1(BuildContext context) async {
    const snackBarinternet = SnackBar(
        content: Text("👍 Bewertung abgegeben"),
        backgroundColor: Colors.blueGrey,
        elevation: 6,
        duration: Duration(seconds: 2));
    ScaffoldMessenger.of(context).showSnackBar(snackBarinternet);
  }

  Future<void> showSnackBar2(BuildContext context) async {
    const snackBarinternet = SnackBar(
        content: Text("Dieses Gericht hast du schon bewertet. 🙃"),
        backgroundColor: Colors.blueGrey,
        elevation: 6,
        duration: Duration(seconds: 2));
    ScaffoldMessenger.of(context).showSnackBar(snackBarinternet);
  }

  /*
  void _getlastRatingDate() async {
    SharedPreferences olddate = await SharedPreferences.getInstance();
    String? ratedDate = olddate.getString("ratedDate");
    setState(() {
      _lastRatingDate = ratedDate;
    });
  }
  */
  /*

  void _setRatingDate() async {
    SharedPreferences olddate = await SharedPreferences.getInstance();
    String datumheute = DateFormat("yyyy-MM-dd").format(DateTime.now());
    await olddate.setString("ratedDate", datumheute);
    setState(() {
      _lastRatingDate = datumheute;
    });
  }
  */
  Future<List<int>> readListFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? list = prefs.getStringList("ratedDishesmem");
    if (list == null) {
      return [];
    }

    List<int> intIDliste = [];
    for (String stringID in list) {
      intIDliste.add(int.parse(stringID));
    }
    return intIDliste;
  }

  Future<void> writeListToStorage(List<int> list) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        "ratedDishesmem", list.map((e) => e.toString()).toList());
  }

  void sendMealsbacktoOle(String jsonbody) {
    try {
      String mealsFromFritzLink = decideMensi(widget.mensiID)[1];
      http.post(
        Uri.parse(mealsFromFritzLink),
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods":
              "POST, GET, OPTIONS, PUT, DELETE, HEAD",
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonbody,
      );
    } on Exception catch (_) {}
  }

  Color decideAppBarcolor(String category) {
    Color appbarcolor;
    if (category == "Vegetarisches Gericht") {
      appbarcolor = const Color.fromARGB(255, 59, 215, 67);
    } else if (category == "Fleischgericht") {
      appbarcolor = const Color.fromARGB(255, 244, 120, 32);
    } else if (category == "Veganes Gericht") {
      appbarcolor = const Color.fromARGB(255, 138, 238, 143);
    } else if (category == "Pastateller") {
      appbarcolor = const Color.fromRGBO(210, 180, 140, 1);
    } else if (category == "Fischgericht") {
      appbarcolor = const Color.fromARGB(255, 52, 174, 236);
    } else {
      appbarcolor = Colors.white;
    }
    return appbarcolor;
  }

  @override
  Widget build(BuildContext context) {
    if (DateFormat("yyyy-MM-dd").format(widget.dishdetailed.servingDate) ==
        DateFormat("yyy-MM-dd").format(DateTime.now())) {
      return Scaffold(
        appBar: AppBar(
          title: Text(pagename),
          backgroundColor: decideAppBarcolor(widget.dishdetailed.category),
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
              Hero(
                tag: widget.dishdetailed.id,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(2, 2),
                        spreadRadius: 2,
                      ),
                    ],
                    gradient: LinearGradient(
                      colors:
                          decideContainerColor(widget.dishdetailed.category),
                      stops: const [0, 1],
                      begin: const AlignmentDirectional(0, -1),
                      end: const AlignmentDirectional(0, 1),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 8, 0),
                                    child: decideIconFile(
                                        widget.dishdetailed.category),
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.dishdetailed.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontFamily: "Open Sans",
                                            fontSize: 19,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 4, 4, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Preis: ${widget.dishdetailed.price}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                                fontFamily: "Open Sans",
                                                fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 4, 4, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Beilagen & Zutaten: ${widget.dishdetailed.description}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(
                                                fontFamily: "Open Sans",
                                                fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              8, 8, 8, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          const Icon(
                                            Icons.star_rounded,
                                            color: Color(0xFFE47B13),
                                            size: 24,
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 6, 0),
                                            child: Text(
                                              "${widget.dishdetailed.rating} / 5",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.copyWith(
                                                      fontFamily: "Open Sans",
                                                      fontSize: 15),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(children: [
                                        Text(
                                          "Votes: ${widget.dishdetailed.votes}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.copyWith(
                                                  fontFamily: "Open Sans",
                                                  fontSize: 15),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
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
                                mapratingvalues["taste"] = newValue;
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
                                mapratingvalues["look"] = newValue;
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
                                mapratingvalues["price"] = newValue;
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
                              onPressed: () async {
                                Dish dishobj = widget.dishdetailed;
                                List<int> ratedDishesIDList =
                                    await readListFromStorage();
                                if (ratedDishesIDList.contains(dishobj.id)) {
                                  //** Restrict User from rating
                                  showSnackBar2(context);
                                } else {
                                  double sum = mapratingvalues.values.reduce(
                                      (value, element) => value + element);
                                  double ratingvalue =
                                      sum / mapratingvalues.length;
                                  //** Let User rate
                                  Dish dishtosend = Dish(
                                      id: dishobj.id,
                                      name: dishobj.name,
                                      servingDate: dishobj.servingDate,
                                      category: dishobj.category,
                                      price: dishobj.price,
                                      description: dishobj.description,
                                      rating: ratingvalue,
                                      responseCode: dishobj.responseCode,
                                      votes: dishobj.votes);
                                  // Convert the Dish object to JSON
                                  String dishjsontosend = dishtosend.toJson();
                                  print(dishjsontosend);
                                  sendMealsbacktoOle(dishjsontosend);
                                  showSnackBar1(context);

                                  ratedDishesIDList.add(dishobj.id);
                                  writeListToStorage(ratedDishesIDList);
                                }
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    30, 5, 30, 5),
                                child: Text(
                                  "Bewerten",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontFamily: "Open Sans",
                                          fontSize: 20,
                                          color: Colors.white),
                                ),
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
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(pagename),
          backgroundColor: decideAppBarcolor(widget.dishdetailed.category),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: GestureDetector(
            child: Column(
              children: [
                Hero(
                    tag: widget.dishdetailed.id,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(2, 2),
                            spreadRadius: 2,
                          ),
                        ],
                        gradient: LinearGradient(
                          colors: decideContainerColor(
                              widget.dishdetailed.category),
                          stops: const [0, 1],
                          begin: const AlignmentDirectional(0, -1),
                          end: const AlignmentDirectional(0, 1),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 8, 0),
                                        child: decideIconFile(
                                            widget.dishdetailed.category),
                                      ),
                                      Expanded(
                                        child: Text(
                                          widget.dishdetailed.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                fontFamily: "Open Sans",
                                                fontSize: 19,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 4, 4, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Preis: ${widget.dishdetailed.price}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.copyWith(
                                                    fontFamily: "Open Sans",
                                                    fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 4, 4, 0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Beilagen & Zutaten: ${widget.dishdetailed.description}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.copyWith(
                                                    fontFamily: "Open Sans",
                                                    fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 8, 8, 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8, 8, 8, 0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              const Icon(
                                                Icons.star_rounded,
                                                color: Color(0xFFE47B13),
                                                size: 24,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 6, 0),
                                                child: Text(
                                                  "${widget.dishdetailed.rating} / 5",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      ?.copyWith(
                                                          fontFamily:
                                                              "Open Sans",
                                                          fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(children: [
                                            Text(
                                              "Votes: ${widget.dishdetailed.votes}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.copyWith(
                                                      fontFamily: "Open Sans",
                                                      fontSize: 15),
                                            ),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
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
      );
    }
  }
}
