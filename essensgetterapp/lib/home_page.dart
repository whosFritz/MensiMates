import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'aboutpage_widget.dart';
import 'mensi_class.dart';
import 'mensi_schedule.dart';
import 'navigation_drawer.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({Key? key, required this.rateMyApp}) : super(key: key);
  final RateMyApp rateMyApp;

  @override
  HomeScreenWidgetState createState() => HomeScreenWidgetState();
}

Mensi shortcutreturn(String type) {
  for (final mensi in mensenliste) {
    if (mensi.name == type) {
      return mensi;
    }
  }
  return Mensi(
    id: 0,
    name: 'keine Mensa',
    oeffnungszeitenalles: ['immer'],
    imageLink: 'nix',
  );
}

class HomeScreenWidgetState extends State<HomeScreenWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    const QuickActions quickActions = QuickActions();

    quickActions.setShortcutItems(
      [
        for (final mensi in mensenliste)
          ShortcutItem(
            type: mensi.name,
            localizedTitle: mensi.name,
            icon: 'launcher_icon',
          ),
      ],
    );

    quickActions.initialize((type) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MensiSchedule(mensiObj: shortcutreturn(type)),
        ),
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildMensenBoxes() {
    List<Widget> listeVonBoxen = [];
    var children = functionStuff(listeVonBoxen);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        controller: _scrollController, // Add the ScrollController here
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: children,
      ),
    );
  }

  List<Widget> functionStuff(List<Widget> listeVonBoxen) {
    for (var mensi in mensenliste) {
      listeVonBoxen.add(
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MensiSchedule(
                  mensiObj: mensi,
                ),
              ),
            );
          },
          child: Stack(children: [
            SizedBox(
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5))),
            Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white60, Colors.white38]),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                      width: 1, color: Colors.white30.withOpacity(0.5))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Image.asset(
                      mensi.imageLink,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white.withOpacity(0.6)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          mensi.name,
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      );
    }
    return listeVonBoxen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Startseite'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GestureDetector(
          // Remove the GestureDetector if not required
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(141, 252, 255, 100),
                    Color.fromRGBO(105, 236, 255, 100)
                  ], begin: Alignment.topCenter, end: Alignment.bottomRight),
                  // image: DecorationImage(
                  //   image: AssetImage(
                  //       'assets/images/backgrounds/pizza-background.jpg'),
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
              Column(
                children: [
                  Expanded(
                    child: CupertinoScrollbar(
                      controller:
                          _scrollController, // Assign the ScrollController here
                      child: buildMensenBoxes(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(children: [
                      BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10)),
                      Container(
                        width: 150,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomCenter,
                                colors: [Colors.white60, Colors.white38]),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                                width: 1,
                                color: Colors.white30.withOpacity(0.5))),
                        child: ListTile(
                          leading: const Icon(Icons.info_outline_rounded),
                          title: const Text('About'),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const AboutPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ]),
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
