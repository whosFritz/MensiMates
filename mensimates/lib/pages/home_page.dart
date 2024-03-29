import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:quick_actions/quick_actions.dart";
import "package:rate_my_app/rate_my_app.dart";

import '../entities/mensi_class.dart';
import '../utils/variables.dart';
import 'aboutpage_widget.dart';
import 'mensi_schedule.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key, required this.rateMyApp});

  final RateMyApp rateMyApp;

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

Mensi shortcutreturn(String type) {
  for (final mensi in mensenList) {
    if (mensi.name == type) {
      return mensi;
    }
  }
  return Mensi(
      id: 0,
      name: "keine Mensa",
      oeffnungszeitenalles: ["immer"],
      imageLink: 'nix');
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    const QuickActions quickActions = QuickActions();

    quickActions.setShortcutItems(<ShortcutItem>[
      for (final mensi in mensenList)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text("Home"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 30, 10, 30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Wo möchtest du speisen?",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: "Open Sans",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  "👀",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Center(
                      child: CupertinoScrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: mensenList.length,
                          itemBuilder: (context, index) {
                            final mensi = mensenList[index];
                            return ListTile(
                              leading: const Icon(Icons.fastfood_outlined),
                              title: Text(mensi.name),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MensiSchedule(
                                    mensiObj: mensi,
                                  ),
                                ));
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
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
