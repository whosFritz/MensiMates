import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:http/http.dart" as http;
import "package:intl/date_symbol_data_local.dart";
import "package:intl/intl.dart";
import "aboutpage_widget.dart";
import "detailedpage_widget.dart";
import "dish_class.dart";
import "api_links.dart";
import "package:flutter/foundation.dart";
import "package:flutter_neumorphic/flutter_neumorphic.dart";
import "dish_helper_class.dart";
import "dishgroup.dart";
import 'mensi_schedule.dart';

void main() {
  initializeDateFormatting("de_DE");
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);
  runApp(const MensiMates());
}
class MensiMates extends StatelessWidget {
  const MensiMates({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/home": (context) => const MensiSchedule(),
        "/aboutpage": (context) => const AboutPage(),
      },
      title: "MensiMates",
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "Open Sans"),
      home: const MensiSchedule(),
    );
  }
}

