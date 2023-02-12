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

  void showSnackbar3(BuildContext context) {
    const snackBarallesRaten = SnackBar(
        content: Text("Bitte Bewertung vollständig ausfüllen."),
        backgroundColor: Colors.blueGrey,
        elevation: 6,
        duration: Duration(seconds: 2));
    ScaffoldMessenger.of(context).showSnackBar(snackBarallesRaten);
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

}
