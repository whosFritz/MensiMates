import "package:flutter/material.dart";
import "mensi_schedule.dart";
import "mensi_class.dart";
import "navigation_drawer.dart";
import "package:quick_actions/quick_actions.dart";

Mensi shortcutreturn(String type) {
  for (final mensi in mensenliste) {
    if (mensi.name == type) {
      return mensi;
    }
  }
  return Mensi(id: 0, name: "keine Mensa", oeffnungszeitenalles: ["immer"]);
}

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
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
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 30, 10, 30),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Wo möchtest du speisen? 👀",
                          style:
                              TextStyle(fontSize: 20, fontFamily: "Open Sans"),
                        ),
                      )),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                    child: ListView.builder(
                        itemCount: mensenliste.length,
                        itemBuilder: ((context, index) {
                          final mensi = mensenliste[index];
                          return ListTile(
                            leading: const Icon(Icons.fastfood_outlined),
                            title: Text(mensi.name),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MensiSchedule(
                                        mensiobj: mensi,
                                      )));
                            },
                          );
                        })),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
