import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import "package:flutter_rating_bar/flutter_rating_bar.dart";
import "package:intl/intl.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:http/http.dart" as http;
import "dish_class.dart";
import "main.dart";
import 'api_links.dart';

class DetailRatingPage extends StatefulWidget {
  final Dish dishdetailed;

  const DetailRatingPage({Key? key, required this.dishdetailed})
      : super(key: key);

  @override
  State<DetailRatingPage> createState() => _DetailRatingPageState();
}

class _DetailRatingPageState extends State<DetailRatingPage> {
  late double ratingbarvalue = 5;

  // Variablen
  String? _lastRatingDate = "2023-01-12";

  @override
  void initState() {
    super.initState();
    _getlastRatingDate();
  }

  Future<void> showSnackBar1(BuildContext context) async {
    const snackBar1 = SnackBar(
        content: Text("👍 Bewertung abgegeben"),
        backgroundColor: Colors.blueGrey,
        elevation: 6,
        duration: Duration(seconds: 2));
    ScaffoldMessenger.of(context).showSnackBar(snackBar1);
  }

  void showSnackBar2(BuildContext context) {
    const snackBar2 = SnackBar(
        content: Text("Heute hast du schon bewertet.🙃"),
        backgroundColor: Colors.blueGrey,
        elevation: 6,
        duration: Duration(seconds: 2));
    ScaffoldMessenger.of(context).showSnackBar(snackBar2);
  }

  void _getlastRatingDate() async {
    SharedPreferences olddate = await SharedPreferences.getInstance();
    String? ratedDate = olddate.getString("ratedDate");
    setState(() {
      _lastRatingDate = ratedDate;
    });
  }

  void _setRatingDate() async {
    SharedPreferences olddate = await SharedPreferences.getInstance();
    String datumheute = DateFormat("yyyy-MM-dd").format(DateTime.now());
    await olddate.setString("ratedDate", datumheute);
    setState(() {
      _lastRatingDate = datumheute;
    });
  }

  void sendMealsbacktoOle(String jsonbody) {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      http.post(
        Uri.parse(apiforsendinglinkothers),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonbody,
      );
    } else {
      http.post(
        Uri.parse(apiforsendinglinkweb),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonbody,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dishdetailed.servingDate ==
        DateFormat("yyyy-MM-dd").format(DateTime.now())) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Detailansicht"),
          backgroundColor: Colors.lightGreen,
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
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            30, 30, 30, 30),
                        child: Hero(
                          tag: widget.dishdetailed.id,
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
                                    widget.dishdetailed.category),
                                stops: const [0, 1],
                                begin: const AlignmentDirectional(0, -1),
                                end: const AlignmentDirectional(0, 1),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            8, 8, 8, 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8, 0, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 8, 0),
                                                child: decideIconFile(widget
                                                    .dishdetailed.category),
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
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 4, 4, 0),
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
                                                  "Beilagen & Zutaten: ${widget.dishdetailed.description}",
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
                                                      .fromSTEB(0, 0, 6, 0),
                                              child: Text(
                                                "${widget.dishdetailed.rating}",
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      onRatingUpdate: (newValue) {
                        setState(() {
                          ratingbarvalue = newValue;
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
                                    borderRadius: BorderRadius.circular(15)))),
                        onPressed: () async {
                          if (_lastRatingDate ==
                              DateFormat("yyyy-MM-dd").format(DateTime.now())) {
                            // Restrict User rating
                            showSnackBar2(context);
                          } else {
                            //Let User rate
                            Dish dishtosend = Dish(
                                id: widget.dishdetailed.id,
                                name: widget.dishdetailed.name,
                                servingDate: widget.dishdetailed.servingDate,
                                category: widget.dishdetailed.category,
                                price: widget.dishdetailed.price,
                                description: widget.dishdetailed.description,
                                rating: ratingbarvalue,
                                responseCode: widget.dishdetailed.responseCode);
                            // Convert the Dish object to JSON
                            String dishjsontosend = dishtosend.toJson();
                            sendMealsbacktoOle(dishjsontosend);
                            _setRatingDate();
                            showSnackBar1(context);
                          }
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
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Detailansicht"),
          backgroundColor: Colors.lightGreen,
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
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(30, 30, 30, 30),
                        child: Hero(
                          tag: widget.dishdetailed.id,
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
                                    widget.dishdetailed.category),
                                stops: const [0, 1],
                                begin: const AlignmentDirectional(0, -1),
                                end: const AlignmentDirectional(0, 1),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            8, 8, 8, 8),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(8, 0, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 8, 0),
                                                child: decideIconFile(widget
                                                    .dishdetailed.category),
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
                                        ),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 4, 4, 0),
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
                                                  "Beilagen & Zutaten: ${widget.dishdetailed.description}",
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
                                                      .fromSTEB(0, 0, 6, 0),
                                              child: Text(
                                                "${widget.dishdetailed.rating}",
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
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20, 5, 20, 5),
                              child: Text(
                                "Heute kannst du nicht abstimmen.",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        fontFamily: "Open Sans", fontSize: 15),
                              ),
                            )
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
      );
    }
  }
}
