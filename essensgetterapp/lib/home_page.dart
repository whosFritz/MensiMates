import "package:flutter/material.dart";
import "package:quick_actions/quick_actions.dart";
import "aboutpage_widget.dart";
import "mensi_class.dart";
import "mensi_schedule.dart";
import "navigation_drawer.dart";

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

Mensi shortcutreturn(String type) {
  for (final mensi in mensenliste) {
    if (mensi.name == type) {
      return mensi;
    }
  }
  return Mensi(id: 0, name: "keine Mensa", oeffnungszeitenalles: ["immer"]);
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
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
                      child: ListView.builder(
                        itemCount: mensenliste.length,
                        itemBuilder: (context, index) {
                          final mensi = mensenliste[index];
                          return ListTile(
                            leading: const Icon(Icons.fastfood_outlined),
                            title: Text(mensi.name),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MensiSchedule(
                                  mensiobj: mensi,
                                ),
                              ));
                            },
                          );
                        },
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
                )
              ],
            ),
          ),
        ));
  }
}
