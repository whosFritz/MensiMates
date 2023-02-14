import 'package:essensgetterapp/home_page.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:intl/date_symbol_data_local.dart";
import "package:flutter_neumorphic/flutter_neumorphic.dart";
import "package:quick_actions/quick_actions.dart";

import "mensi_class.dart";
import "mensi_schedule.dart";
import "navigation_drawer.dart";

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

Mensi shortcutreturn(String type) {
  for (final mensi in mensenliste) {
    if (mensi.name == type) {
      return mensi;
    }
  }
  return Mensi(id: 0, name: "keine Mensa", oeffnungszeitenalles: ["immer"]);
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

    const QuickActions quickActions = QuickActions();

    quickActions.setShortcutItems(<ShortcutItem>[
      for (final mensi in mensenliste)
        ShortcutItem(
            type: mensi.name, localizedTitle: mensi.name, icon: "launcher_icon")
    ]);

    quickActions.initialize((type) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MensiSchedule(mensiobj: shortcutreturn(type))));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Open Sans"),
      home: const HomeScreenWidget(),
    );
  }
}
