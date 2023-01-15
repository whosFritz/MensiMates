import "dart:async";
import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:intl/intl.dart";
import "package:http/http.dart" as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
  runApp(const MensenApp());
}

class HomePageWidget extends StatefulWidget {
  final List<dynamic> jsondata;
  final String title;
  const HomePageWidget(
      {super.key, required this.title, required this.jsondata});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class MensenApp extends StatelessWidget {
  const MensenApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MensaApp",
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Open Sans"),
      home: const HomePageWidget(
        title: "Speiseplan",
        jsondata: [],
      ),
    );
  }
}

Image decideIconFile(String iconmealtype) {
  if (iconmealtype == "vegan") {
    return Image.asset("assets/images/vegan-icon.png",
        width: 25, height: 25, fit: BoxFit.cover);
  } else if (iconmealtype == "vegetarian") {
    return Image.asset("assets/images/vegetarian-icon.png",
        width: 25, height: 25, fit: BoxFit.cover);
  } else if (iconmealtype == "chicken") {
    return Image.asset("assets/images/chicken-icon.png",
        width: 25, height: 25, fit: BoxFit.cover);
  } else if (iconmealtype == "meat") {
    return Image.asset("assets/images/meat-icon.png",
        width: 25, height: 25, fit: BoxFit.cover);
  } else if (iconmealtype == "fish") {
    return Image.asset("assets/images/fish-icon.png",
        width: 25, height: 25, fit: BoxFit.cover);
  } else {
    return Image.asset("assets/images/default-icon.png",
        width: 25, height: 25, fit: BoxFit.cover);
  }
}

List<Color> decideContainerColor(String mealtype) {
  List<Color> colors = [];
  if (mealtype == "vegan") {
    colors = [
      const Color.fromARGB(255, 0, 218, 65),
      const Color.fromARGB(255, 0, 255, 42)
    ];
  } else if (mealtype == "vegetarian") {
    colors = [
      const Color.fromARGB(255, 59, 215, 67),
      const Color.fromARGB(255, 18, 213, 151)
    ];
  } else if (mealtype == "chicken") {
    colors = [
      const Color.fromARGB(255, 207, 141, 66),
      const Color.fromARGB(255, 201, 129, 48)
    ];
  } else if (mealtype == "meat") {
    colors = [
      const Color.fromARGB(255, 244, 120, 32),
      const Color.fromARGB(255, 220, 102, 13)
    ];
  } else if (mealtype == "fish") {
    colors = [
      const Color.fromARGB(255, 18, 176, 255),
      const Color.fromARGB(255, 9, 142, 194)
    ];
  } else {
    colors = [Colors.white, Colors.white];
  }
  return colors;
}

class _HomePageWidgetState extends State<HomePageWidget> {
  List jsondata = [];
  bool _isLoading = true;

  DateTime _date = DateTime.now();
  List<dynamic> _filteredMeals = [];

  void _filterMeals() {
    _filteredMeals = jsondata.where((jsondata) {
      String formattedDate = DateFormat("dd.MM.yyyy").format(_date);
      return jsondata["Date"] == formattedDate;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    try {
      final response = await http.get(Uri.parse(
          "https://raw.githubusercontent.com/whosFritz/Mensa-App/master/essensgetterapp/assets/testtingdata.json"));
      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
          jsondata = jsonDecode(response.body);
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(4, 2, 4, 2),
                child: Text(
                  "Mensa Speiseplan",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: "Open Sans",
                        color: Colors.black,
                        fontSize: 20,
                        letterSpacing: 2,
                      ),
                ),
              ),
            ),
          ],
        ),
        actions: const [],
        flexibleSpace: FlexibleSpaceBar(
          background: Image.asset(
            "assets/images/appbar-header-brokoli.jpg",
            fit: BoxFit.cover,
          ),
        ),
        centerTitle: false,
        elevation: 2,
      ),
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
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(40, 8, 40, 8),
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
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _date = _date
                                            .subtract(const Duration(days: 1));
                                        _filterMeals();
                                      });
                                    },
                                    child: const Icon(Icons.arrow_left_rounded),
                                  ),
                                  InkWell(
                                    child: Text(
                                        DateFormat("dd.MM.yyyy").format(_date)),
                                    onTap: () async {
                                      final DateTime? picked =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: _date,
                                        firstDate: DateTime(2010),
                                        lastDate: DateTime(2100),
                                      );
                                      if (picked != _date) {
                                        setState(() {
                                          _date = picked!;
                                          _filterMeals();
                                        });
                                      }
                                    },
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _date =
                                            _date.add(const Duration(days: 1));
                                        _filterMeals();
                                      });
                                    },
                                    child:
                                        const Icon(Icons.arrow_right_rounded),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
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
                  child: RefreshIndicator(
                onRefresh: () async {
                  await loadData();
                },
                child: ListView.builder(
                  itemCount: _filteredMeals.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (_isLoading) {
                      return const CircularProgressIndicator();
                    } else {
                      return Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    30, 30, 30, 30),
                                child: Container(
                                  width: double.infinity,
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
                                          _filteredMeals[index]["Mealtype"]),
                                      stops: const [0, 1],
                                      begin: const AlignmentDirectional(0, -1),
                                      end: const AlignmentDirectional(0, 1),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8, 8, 8, 8),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  decideIconFile(
                                                      _filteredMeals[index]
                                                          ["Mealtype"]),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            8, 0, 0, 0),
                                                    child: Text(
                                                      _filteredMeals[index]
                                                          ["Gerichtname"],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                          ?.copyWith(
                                                            fontFamily:
                                                                "Open Sans",
                                                            fontSize: 18,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            0, 4, 4, 0),
                                                    child: Text(
                                                      "Preis: ${_filteredMeals[index]["Preis"]}",
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
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            0, 4, 4, 0),
                                                    child: Text(
                                                      "Beilagen: ${_filteredMeals[index]["Beilagen"]}",
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
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                                .fromSTEB(
                                                            0, 4, 4, 0),
                                                    child: Text(
                                                      "Allergene: ${_filteredMeals[index]["Allergene"]}",
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
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(8, 8, 8, 8),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Row(
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
                                                                .fromSTEB(
                                                            0, 0, 4, 0),
                                                    child: Text(
                                                        _filteredMeals[index]
                                                            ["Bewertung"]),
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
                          ]);
                    }
                  },
                ),
              )),
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
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(7, 7, 7, 7),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 0, 0),
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 0),
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 0, 0),
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
