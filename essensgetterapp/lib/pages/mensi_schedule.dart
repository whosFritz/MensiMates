import 'package:essensgetterapp/pages/webpagepicsearch_page.dart';
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:intl/intl.dart";

import '../components/navigation_drawer.dart';
import '../entities/dish_class.dart';
import '../entities/dishgroup_cat.dart';
import '../entities/dishgroup_date.dart';
import '../entities/mensi_class.dart';
import '../utils/methods.dart';

late Future<List<Dish>> dishesFromApi;
late PageController pageController;
late List<DishGroupDate> groupedDishesDat;
int indexToBeReturned = 1;

class MensiSchedule extends StatefulWidget {
  final Mensi mensiObj;

  const MensiSchedule({super.key, required this.mensiObj});

  @override
  State<MensiSchedule> createState() {
    return MensiScheduleState();
  }
}

class MensiScheduleState extends State<MensiSchedule>
    with TickerProviderStateMixin {
  // Variablen
  int currentPage = 0;
  DateTime anzeigeDatum = DateTime.now(), heute = DateTime.now();
  // ignore: prefer_final_fields
  Map<int, bool> _expansionState = {};
  final sortOrder = {
    "Aktion": 0,
    "mensaVital": 1,
    "Vegetarisches Gericht": 2,
    "Veganes Gericht": 3,
    "Salat": 4,
    "Fleischgericht": 5,
    "Fischgericht": 6,
    "Pizza": 7,
    "Suppe / Eintopf": 8,
    "Pastateller": 9,
    "WOK": 10,
    "Schneller Teller": 11,
    "Grill": 12,
    "Dessert": 13,
    "Smoothie": 14,
    "Sättigungsbeilage": 15,
    "Hauptkomponente": 16,
    "Gemüsebeilage": 17,
    "Beilagen": 18,
    "N/A": 19
  };
  int compareDishGroupCat(DishGroupCat a, DishGroupCat b) {
    int differenz = sortOrder[a.kategorie]! - sortOrder[b.kategorie]!;
    return differenz;
  }

  // Initiierung
  @override
  void initState() {
    setState(() {
      // dishesfromOle = getDishesfromOle(widget.mensiobj);
      dishesFromApi = fetchDataWithJwtToken(widget.mensiObj);
    });
    super.initState();
  }

  void skipToYesterday() {
    pageController.previousPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void skipToNextDay() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void handleKeyDownEvent(RawKeyDownEvent event) {
    final pressedKey = event.logicalKey;
    switch (pressedKey.keyLabel) {
      case "Arrow Left":
        skipToYesterday();
        break;
      case "Arrow Right":
        skipToNextDay();
        break;
      case "R":
        refresh();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.black,
      title: widget.mensiObj.name,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) =>
            event is RawKeyDownEvent ? handleKeyDownEvent(event) : null,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: platformPageViewButtons())
            ],
            iconTheme: const IconThemeData(color: Colors.blueGrey),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                widget.mensiObj.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Open Sans",
                    fontSize: 20,
                    color: Colors.black,
                    letterSpacing: 2),
              ),
            ),
          ),
          drawer: MyNavigationDrawer(
            mensipara: widget.mensiObj,
          ),
          body: SafeArea(
            child: GestureDetector(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: FutureBuilder(
                          future: dishesFromApi,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              Object? errormessage = snapshot.error;
                              if (errormessage.toString() ==
                                  "Failed host lookup: 'api.olech2412.de'") {
                                return const Text("🥵 API-Error 🥵");
                              } else {
                                return Text("🤮 $errormessage 🤮");
                              }
                            } else if (snapshot.hasData &&
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  "Es konnten keine Daten abgerufen werden.🤭",
                                  textAlign: TextAlign.center,
                                ),
                              );
                            } else if (snapshot.hasData) {
                              final dishes = snapshot.data!;
                              return buildDishes(dishes);
                            } else {
                              return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffE0E0E0),
                              borderRadius: BorderRadius.circular(0),
                              shape: BoxShape.rectangle),
                          child: Padding(
                            padding: const EdgeInsets.all(7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Öffnungszeiten:",
                                  style: TextStyle(
                                      fontFamily: "Open Sans",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                                for (String zeile
                                    in widget.mensiObj.oeffnungszeitenalles)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7),
                                    child: Text(
                                      zeile,
                                      style: const TextStyle(
                                          fontFamily: "Open Sans",
                                          fontSize: 12),
                                    ),
                                  ),
                              ],
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
        ),
      ),
    );
  }

  // Methde, welche aufgerufen wird, wenn die ListView der Gerichte nach unten gezogen wird.
  Future refresh() async {
    setState(() {
      dishesFromApi = fetchDataWithJwtToken(widget.mensiObj);
      // dishesfromOle = getDishesfromOle(widget.mensiobj);
    });
  }

  Widget platformPageViewButtons() {
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      return Row(
        children: [
          Tooltip(
            message: "Vorheriger Tag",
            child: IconButton(
                onPressed: () => skipToYesterday(),
                icon: const Icon(Icons.keyboard_arrow_left_rounded)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Tooltip(
              message: "Nächster Tag",
              child: IconButton(
                  onPressed: () => skipToNextDay(),
                  icon: const Icon(Icons.keyboard_arrow_right_rounded)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: Tooltip(
              message: "Aktualisieren",
              child: IconButton(
                icon: const SizedBox(
                  height: 24 * 1.5,
                  width: 24 * 1.5,
                  child: Icon(Icons.sync),
                ),
                onPressed: () {
                  refresh();
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          IconButton(
            icon: const SizedBox(
              height: 24 * 1.5,
              width: 24 * 1.5,
              child: Icon(Icons.sync),
            ),
            onPressed: () {
              refresh();
            },
          ),
        ],
      );
    }
  }

  // Reload button nur für die WebApp
  Widget platformRefreshButton() {
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
  }

  List<DishGroupDate> groupByDate(List<Dish> dishes) {
    final groups = <DateTime, DishGroupDate>{};
    for (final dish in dishes) {
      final date = dish.servingDate;
      if (!groups.containsKey(date)) {
        groups[date] = DishGroupDate(date, []);
      }
      groups[date]!.gerichteingruppe.add(dish);
    }
    return groups.values.toList();
  }

  List<DishGroupCat> groupByCat(List<Dish> dishes) {
    final groups = <String, DishGroupCat>{};
    for (final dish in dishes) {
      final cat = dish.category;
      if (!groups.containsKey(cat)) {
        int anzahl = 0;
        groups[cat] = DishGroupCat(
            kategorie: cat,
            gerichteingruppe: [],
            isexpanded: false,
            anzahlgerichte: anzahl);
      }
      groups[cat]!.gerichteingruppe.add(dish);
      groups[cat]!.anzahlgerichte += 1;
    }
    List<DishGroupCat> gruppenListeCat = groups.values.toList();
    //  gruppenListeCat.sort((a, b) => a.kategorie.compareTo(b.kategorie));
    gruppenListeCat.sort(compareDishGroupCat);
    return gruppenListeCat;
  }

  int findInitalPageDisplay(List<DishGroupDate> groupedDishesDat) {
    int i = 0;
    for (final gruppe in groupedDishesDat) {
      if (DateFormat("yyyy-MM-dd").format(gruppe.date) ==
          DateFormat("yyyy-MM-dd").format(heute)) {
        indexToBeReturned = i;
        break;
      }
      i++;
    }
    return indexToBeReturned;
  }

  // Widget zur Listerstellung
  Widget buildDishes(List<Dish> dishes) {
    groupedDishesDat = groupByDate(dishes);
    pageController =
        PageController(initialPage: findInitalPageDisplay(groupedDishesDat));
    return PageView.builder(
        controller: pageController,
        itemCount: groupedDishesDat.length,
        onPageChanged: (int index) {
          setState(() {
            anzeigeDatum = groupedDishesDat[index].date;
            // * _expansionState = {};
          });
          currentPage =
              index; // ? remove?, weil das war mal button überbleibsel
        },
        itemBuilder: (context, index) {
          final grouppedByCatList =
              groupByCat(groupedDishesDat[index].gerichteingruppe);
          return SingleChildScrollView(
            child: Column(children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
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
                                .format(groupedDishesDat[index].date))
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
              SingleChildScrollView(
                child: ExpansionPanelList(
                  animationDuration: const Duration(milliseconds: 600),
                  expansionCallback: (panelIndex, isExpanded) {
                    setState(() {
                      _expansionState[panelIndex] = !isExpanded;
                    });
                  },
                  children: buildExpansionPanels(grouppedByCatList),
                ),
              )
            ]),
          );
        });
  }

  List<ExpansionPanel> buildExpansionPanels(
      List<DishGroupCat> grouppedByCatList) {
    List<ExpansionPanel> expandedList = [];
    for (int i = 0; i < grouppedByCatList.length; i++) {
      final grouppedByCat = grouppedByCatList[i];
      expandedList.add(
        ExpansionPanel(
          canTapOnHeader: true,
          backgroundColor: decideContainerColor(grouppedByCat.kategorie),
          headerBuilder: (BuildContext context, bool isExpanded) {
            return FittedBox(
              fit: BoxFit.fitWidth,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 4, 4, 4),
                    child: decideIconFile(grouppedByCat.kategorie),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      "${grouppedByCat.kategorie}: (${grouppedByCat.anzahlgerichte})",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Open Sans",
                          fontSize: 18,
                          color: Colors.black,
                          letterSpacing: 2),
                    ),
                  ),
                ],
              ),
            );
          },
          body: ListView.builder(
            itemCount: grouppedByCat.gerichteingruppe.length,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              Dish dish = grouppedByCat.gerichteingruppe[index];
              return InkWell(
                onTap: () {
                  navigateToDetailRatingPage(context, dish, widget.mensiObj);
                },
                child: buildDishBox(context, dish),
              );
            },
          ),
          isExpanded: _expansionState[i] ?? false,
        ),
      );
    }
    return expandedList;
  }

  static Widget buildDishBox(BuildContext context, Dish dish) {
    return Padding(
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
                    Expanded(
                      child: Text(dish.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              fontFamily: "Open Sans")),
                    ),
                    IconButton(
                      onPressed: () {
                        if (defaultTargetPlatform != TargetPlatform.android &&
                            defaultTargetPlatform != TargetPlatform.iOS) {
                          searchGerichte(dish.name);
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return WebPageSearch(searchDish: dish);
                            },
                          ));
                        }
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 4, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text("Preis: ${dish.price.substring(0, 5)}",
                            style: const TextStyle(
                                fontFamily: "Open Sans", fontSize: 13)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 4, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          "Beilagen & Zutaten: ${dish.description}",
                          style: const TextStyle(
                              fontFamily: "Open Sans", fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
            child: Column(
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
                            const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFE47B13),
                              size: 24,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 6, 0),
                              child: Text(
                                "${dish.rating} / 5",
                                style: const TextStyle(
                                    fontFamily: "Open Sans", fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Text(
                            "Votes: ${dish.votes}",
                            style: const TextStyle(
                                fontFamily: "Open Sans", fontSize: 15),
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
    );
  }
}
