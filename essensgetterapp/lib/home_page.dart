import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:quick_actions/quick_actions.dart";
import "package:rate_my_app/rate_my_app.dart";
import "aboutpage_widget.dart";
import "mensi_class.dart";
import "mensi_schedule.dart";
import "navigation_drawer.dart";

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key, required this.rateMyApp});
  final RateMyApp rateMyApp;
  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

Mensi shortcutreturn(String type) {
  for (final mensi in mensenliste) {
    if (mensi.name == type) {
      return mensi;
    }
  }
  return Mensi(
      id: 0,
      name: "keine Mensa",
      oeffnungszeitenalles: ["immer"],
      imageLink: "nix");
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  final ScrollController _scrollController = ScrollController();

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
                  MensiSchedule(mensiObj: shortcutreturn(type))));
    });
  }

  Widget buildMensenBoxes() {
    List<Widget> listeVonBoxen = [];
    for (var mensi in mensenliste) {
      listeVonBoxen.add(InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MensiSchedule(
              mensiObj: mensi,
            ),
          ));
        },
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            mensi.imageLink,
            height: 50,
            fit: BoxFit.scaleDown,
          ),
          Container(
            child: Text(mensi.name),
          )
        ]),
      ));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: listeVonBoxen,
        spacing: 10,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text("Startseite"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: GestureDetector(
            child: Column(
              children: [
                Center(
                  child: CupertinoScrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: buildMensenBoxes()),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text("About"),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AboutPage()));
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
