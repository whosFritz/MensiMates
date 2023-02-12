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
import 'dishgroup_cat.dart';
import 'dishgroup_date.dart';
import 'navigation_drawer.dart';

class MensiSchedule extends StatefulWidget {
  const MensiSchedule(
      {super.key,
      required this.mensiID,
      required this.mensiName,
      required this.oeffnungszeiten});
  final int mensiID;
  final String mensiName;
  final List<String> oeffnungszeiten;

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
  Map<int, bool> _expansionState = {};

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
        groups[cat] = DishGroupCat(cat, [], false);
      }
      groups[cat]!.gerichteingruppe.add(dish);
    }
    return groups.values.toList();
  }

  // Widget zur Listerstellung
  Widget buildDishes(List<Dish> dishes) {
    final groupedDishesDat = groupByDate(dishes);
    return PageView.builder(
        controller: PageController(initialPage: 2),
        itemCount: groupedDishesDat.length,
        onPageChanged: (int index) {
          setState(() {
            anzeigeDatum = groupedDishesDat[index].date;
            _expansionState = {};
          });
          currentPage =
              index; // ? remove?, weil das war mal button überbleibsel
        },
        itemBuilder: (context, index) {
          final grouppedbycatListe =
              groupByCat(groupedDishesDat[index].gerichteingruppe);
          return SingleChildScrollView(
            child: ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  _expansionState[panelIndex] = !isExpanded;
                });
              },
              children: buildexpansionpanels(grouppedbycatListe),
            ),
          );
        });
  }

  List<ExpansionPanel> buildexpansionpanels(
      List<DishGroupCat> grouppedbycatListe) {
    List<ExpansionPanel> exppanelist = [];
    for (int i = 0; i < grouppedbycatListe.length; i++) {
      final grouppedbycat = grouppedbycatListe[i];
      exppanelist.add(
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(
              grouppedbycat.kategorie,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            );
          },
          body: ListView.builder(
            itemCount: grouppedbycat.gerichteingruppe.length,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              Dish dish = grouppedbycat.gerichteingruppe[index];
              return ListTile(
                title: Text("${dish.name} für ${dish.price.substring(0, 5)}"),
                subtitle: Text(dish.description),
              );
            },
          ),
          isExpanded: _expansionState[i] ?? false,
        ),
      );
    }
    return exppanelist;
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
      drawer: const MyNavigationDrawer(),
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
                      decoration: BoxDecoration(
                          color: const Color(0xffE0E0E0),
                          borderRadius: BorderRadius.circular(0),
                          shape: BoxShape.rectangle),
                      child: Padding(
                        padding: const EdgeInsets.all(7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Öffnungszeiten:",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontFamily: "Open Sans",
                                    fontSize: 15,
                                  ),
                            ),
                            for (String zeile in widget.oeffnungszeiten)
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Text(
                                  zeile,
                                  style: Theme.of(context)
                                      .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                        fontFamily: "Open Sans",
                                        fontSize: 12,
                                      ),
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
    );
  }
}

Image decideIconFile(String iconmealtype) {
  Image icon;
  switch (iconmealtype) {
    case "Vegetarisches Gericht":
      icon = Image.asset("assets/images/vegetarian-icon.png",
          width: 40, fit: BoxFit.cover);
      break;
    case "Fleischgericht":
      icon = Image.asset("assets/images/meat-icon.png",
          width: 40, fit: BoxFit.cover);
      break;
    case "Fischgericht":
      icon = Image.asset("assets/images/fish-icon.png",
          width: 40, fit: BoxFit.cover);
      break;
    case "Veganes Gericht":
      icon = Image.asset("assets/images/vegan-icon.png",
          width: 40, fit: BoxFit.cover);
      break;
    case "Pastateller":
      icon = Image.asset("assets/images/pasta-icon.png",
          width: 40, fit: BoxFit.cover);
      break;
    case "Dessert":
      icon = Image.asset("assets/images/dessert-icon.png",
          width: 40, fit: BoxFit.cover);
      break;
    case "Smoothie":
      icon = Image.asset("assets/images/smoothie-icon.png",
          width: 40, fit: BoxFit.cover);
      break;
    case "WOK":
      icon = Image.asset("assets/images/wok-icon.png",
          width: 40, fit: BoxFit.cover);
      break;
    case "Salat":
      icon = Image.asset("assets/images/salat-icon.png",
          width: 40, fit: BoxFit.cover);
      break;
    case "Gemüsebeilage":
      icon = Image.asset("assets/images/gemuesebeilage-icon.png",
          width: 40, fit: BoxFit.cover);
      break;
    case "Sättigungsbeilage":
      icon = Image.asset("assets/images/saettigungsbeilage-icon.png",
          width: 40, fit: BoxFit.cover);
      break;
    default:
      icon = Image.asset("assets/images/default-icon.png",
          width: 40, height: 40, fit: BoxFit.cover);
      break;
  }
  return icon;
}

List<Color> decideContainerColor(String category) {
  List<Color> colors;
  switch (category) {
    case "Vegetarisches Gericht":
      colors = [
        const Color.fromARGB(255, 69, 218, 77),
        const Color.fromARGB(255, 52, 187, 58),
      ];
      break;
    case "Fleischgericht":
      colors = [
        const Color.fromARGB(255, 244, 120, 32),
        const Color.fromARGB(255, 220, 102, 13)
      ];
      break;
    case "Veganes Gericht":
      colors = [
        const Color.fromARGB(255, 138, 238, 143),
        const Color.fromARGB(255, 125, 213, 130),
      ];
      break;
    case "Pastateller":
      colors = [
        const Color.fromARGB(255, 212, 185, 149),
        const Color.fromARGB(255, 209, 177, 134),
      ];
      break;
    case "Fischgericht":
      colors = [
        const Color.fromARGB(255, 52, 174, 236),
        const Color.fromARGB(255, 37, 169, 235),
      ];
      break;
    case "Dessert":
      colors = [
        const Color.fromARGB(255, 158, 137, 236),
        const Color.fromARGB(255, 134, 107, 230),
      ];
      break;
    case "Smoothie":
      colors = [
        const Color.fromARGB(255, 214, 117, 238),
        const Color.fromARGB(255, 179, 97, 199),
      ];
      break;
    case "WOK":
      colors = [
        const Color.fromARGB(255, 255, 223, 83),
        const Color.fromARGB(255, 211, 183, 58),
      ];
      break;
    case "Salat":
      colors = [
        const Color.fromARGB(255, 31, 150, 41),
        const Color.fromARGB(255, 24, 128, 32),
      ];
      break;
    case "Gemüsebeilage":
      colors = [
        const Color.fromARGB(255, 150, 243, 62),
        const Color.fromARGB(255, 118, 199, 42),
      ];
      break;
    case "Sättigungsbeilage":
      colors = [
        const Color.fromARGB(255, 235, 219, 80),
        const Color.fromARGB(255, 235, 219, 80),
      ];
      break;
    default:
      colors = [Colors.white, Colors.white];
      break;
  }
  return colors;
}
