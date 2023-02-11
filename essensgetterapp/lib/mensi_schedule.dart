import "dart:convert";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:intl/intl.dart";
import 'detailedpage_widget.dart';
import "dish_class.dart";
import "api_links.dart";
import "package:flutter/foundation.dart";
import "package:flutter_neumorphic/flutter_neumorphic.dart";
import "dish_helper_class.dart";
import 'dishgroup.dart';
import 'navigation_drawer.dart';

class MensiSchedule extends StatefulWidget {
  const MensiSchedule(
      {super.key, required this.mensiID, required this.mensiName});
  final int mensiID;
  final String mensiName;

  @override
  State<MensiSchedule> createState() {
    return _MensiScheduleState();
  }
}

class _MensiScheduleState extends State<MensiSchedule>
    with TickerProviderStateMixin {
  // Variablen
  late Future<List<Dish>> dishesfromOle;
  int currentPage = 0;
  DateTime anzeigeDatum = DateTime.now();
  // Initiierung
  @override
  void initState() {
    setState(() {
      dishesfromOle = getDishesfromOle();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Methode um Gerichte zu holen und umzuwandeln.
  Future<List<Dish>> getDishesfromOle() async {
    // ! Caching
    // try {
    String mealsForFritzLink = decideMensi(widget.mensiID)[0];
    final response = await http.get(Uri.parse(mealsForFritzLink)).timeout(
          const Duration(seconds: 6),
        );
    if (response.statusCode == 200) {
      final jsondata = jsonDecode(utf8.decode(response.bodyBytes));
      List<Dish> listvondishes = jsondata.map<Dish>(Dish.fromJson).toList();
      listvondishes.sort((a, b) => a.servingDate.compareTo(b.servingDate));
      //! Caching
      setofflineDishes(listvondishes);
      return listvondishes;
    } else {
      throw Exception();
    }
    /** 
    *! } catch (e) {
    *!  return getofflineDishes();
    *!}
    */
  }
  /*
  // Methode um Gerichte nach Datum zu filtern
  Future<List<Dish>> filterDishes() async {
    final dishes = await dishesfromOle;
    return dishes.where((dish) {
      return dish.servingDate == anzeigeDatum;
    }).toList();
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

//Navigation zur Detailpage
  void navigateToDetailRatingPage(BuildContext context, Dish dishdetailed) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) {
            return DetailRatingPage(
              dishdetailed: dishdetailed,
              mensiID: widget.mensiID,
            );
          },
          fullscreenDialog: true),
    );
  }

  // Methde, welche aufgerufen wird, wenn die ListView der Gerichte nach unten gezogen wird.
  Future refresh() async {
    setState(() {
      dishesfromOle = getDishesfromOle();
    });
  }

  // Reload button nur für die WebApp
  Widget platformrefreshbutton() {
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Color(0x33000000),
                  offset: Offset(2, 2),
                  spreadRadius: 2,
                ),
              ]),
          child: CircleAvatar(
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: refresh,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
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

  // Widget zur Listerstellung
  Widget buildDishes(List<Dish> dishes) {
    final groupedDishes = groupByDate(dishes);
    return PageView.builder(
        controller: PageController(initialPage: 2),
        itemCount: groupedDishes.length,
        onPageChanged: (int index) {
          setState(() {
            anzeigeDatum = groupedDishes[index].date;
          });
          currentPage = index;
        },
        itemBuilder: (context, index) {
          final group = groupedDishes[index];

          /*
          if (group.date != anzeigeDatum) {
            return const Center(child: Text("Keine Daten"));
          }
          */
          return RefreshIndicator(
            onRefresh: refresh,
            child: ListView.builder(
                itemCount: group.dishes.length,
                itemBuilder: (context, index) {
                  final dish = group.dishes[index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: (() {
                          navigateToDetailRatingPage(context, dish);
                        }),
                        child: Hero(
                          tag: dish.id,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
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
                                colors: decideContainerColor(dish.category),
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
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 8, 0),
                                              child:
                                                  decideIconFile(dish.category),
                                            ),
                                            Expanded(
                                              child: Text(
                                                dish.name,
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
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 4, 4, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Preis: ${dish.price}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      ?.copyWith(
                                                          fontFamily:
                                                              "Open Sans",
                                                          fontSize: 13),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 4, 4, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Beilagen & Zutaten: ${dish.description}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      ?.copyWith(
                                                          fontFamily:
                                                              "Open Sans",
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
                                        const EdgeInsetsDirectional.fromSTEB(
                                            8, 8, 8, 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(8, 8, 8, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    const Icon(
                                                      Icons.star_rounded,
                                                      color: Color(0xFFE47B13),
                                                      size: 24,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              0, 0, 6, 0),
                                                      child: Text(
                                                        "${dish.rating} / 5",
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(children: [
                                                  Text(
                                                    "Votes: ${dish.votes}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        ?.copyWith(
                                                            fontFamily:
                                                                "Open Sans",
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
                      ),
                    ],
                  );
                }),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.blueGrey),
        backgroundColor: Colors.white,
        title: Text(
          widget.mensiName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: "Open Sans",
                color: Colors.black,
                fontSize: 20,
                letterSpacing: 2,
              ),
        ),
        centerTitle: true,
      ),
      drawer: const NavigationDrawer(),
      body: SafeArea(
        child: GestureDetector(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(40, 8, 40, 8),
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Color(0x33000000),
                              offset: Offset(0, 2),
                              spreadRadius: 2,
                            )
                          ],
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(DateFormat("E dd.MM.yyyy", "de_DE")
                                .format(anzeigeDatum))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 3,
                color: Color(0xFFFA9C00),
              ),
              const Divider(
                thickness: 3,
                color: Color(0xFFFA9C00),
              ),
              Expanded(
                  child: FutureBuilder(
                      future: dishesfromOle,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          Object? errormessage = snapshot.error;
                          if (errormessage.toString() ==
                              "Failed host lookup: 'api.olech2412.de'") {
                            return const Text("🥵 API Error 🥵");
                          } else {
                            return Text("🤮 $errormessage 🤮");
                          }
                        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              "Keine Speisen an diesem Tag oder noch keine Daten vorhanden.🤭",
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final dishes = snapshot.data!;
                          return buildDishes(dishes);
                        } else {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // works!
                                Container(
                                  alignment: Alignment.center,
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    color: Color.fromARGB(255, 0, 166, 255),
                                  )),
                                )
                              ]);
                        }
                      })),
              platformrefreshbutton(),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 224, 224, 224),
                          borderRadius: BorderRadius.circular(0),
                          shape: BoxShape.rectangle),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  7, 7, 7, 7),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 0),
                                        child: Text("Öffnungszeiten:",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(
                                                  fontFamily: "Open Sans",
                                                  fontSize: 15,
                                                )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8, 0, 0, 0),
                                        child: Text(
                                          "Mo - Fr: 8.30-15.45 Uhr",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontFamily: "Open Sans",
                                                  fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 0),
                                        child: Text("Mittagessen:",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(
                                                  fontFamily: "Open Sans",
                                                  fontSize: 15,
                                                )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8, 0, 0, 0),
                                        child: Text(
                                          "Mo - Fr: 11.30-14.00 Uhr",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontFamily: "Open Sans",
                                                  fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Image decideIconFile(String iconmealtype) {
  if (iconmealtype == "Vegetarisches Gericht") {
    return Image.asset("assets/images/vegetarian-icon.png",
        width: 45, height: 45, fit: BoxFit.cover);
  } else if (iconmealtype == "Fleischgericht") {
    return Image.asset("assets/images/meat-icon.png",
        width: 40, height: 40, fit: BoxFit.cover);
  } else if (iconmealtype == "Fischgericht") {
    return Image.asset("assets/images/fish-icon.png",
        width: 40, height: 40, fit: BoxFit.cover);
  } else if (iconmealtype == "Veganes Gericht") {
    return Image.asset("assets/images/vegan-icon.png",
        width: 40, height: 40, fit: BoxFit.cover);
  } else if (iconmealtype == "Pastateller") {
    return Image.asset("assets/images/pasta-icon.png",
        width: 40, height: 40, fit: BoxFit.cover);
  } else {
    return Image.asset("assets/images/default-icon.png",
        width: 40, height: 40, fit: BoxFit.cover);
  }
}

List<Color> decideContainerColor(String category) {
  List<Color> colors = [];
  if (category == "Vegetarisches Gericht") {
    colors = [
      const Color.fromARGB(255, 59, 215, 67),
      const Color.fromARGB(255, 18, 213, 151)
    ];
  } else if (category == "Fleischgericht") {
    colors = [
      const Color.fromARGB(255, 244, 120, 32),
      const Color.fromARGB(255, 220, 102, 13)
    ];
  } else if (category == "Veganes Gericht") {
    colors = [
      const Color.fromARGB(255, 138, 238, 143),
      const Color.fromARGB(255, 125, 213, 130),
    ];
  } else if (category == "Pastateller") {
    colors = [
      const Color.fromARGB(255, 212, 185, 149),
      const Color.fromARGB(255, 209, 177, 134),
    ];
  } else if (category == "Fischgericht") {
    colors = [
      const Color.fromARGB(255, 52, 174, 236),
      const Color.fromARGB(255, 37, 169, 235),
    ];
  } else {
    colors = [Colors.white, Colors.white];
  }
  return colors;
}
