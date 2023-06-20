import 'package:essensgetterapp/home_page.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:intl/date_symbol_data_local.dart";

import "rate_app_init_widget.dart";

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

class MensiMates extends StatefulWidget {
  const MensiMates({super.key});

  @override
  State<MensiMates> createState() => _MensiMatesState();
}

class _MensiMatesState extends State<MensiMates> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      theme: ThemeData(fontFamily: "Open Sans"),
      title: "MensiMates",
      home: RateAppInitWidget(
        builder: (rateMyApp) => HomeScreenWidget(rateMyApp: rateMyApp),
      ));
}
