import 'package:essensgetterapp/aboutpage_widget.dart';
import 'package:essensgetterapp/home_page.dart';
import 'package:essensgetterapp/mensi_schedule.dart';
import 'package:flutter/material.dart';
import 'mensi_class.dart';

List<Mensi> mensenliste = [
  Mensi(id: 153, name: "Cafeteria Dittrichring", oeffnungszeitenalles: [
    "Montag-Donnerstag 8.00-16.30 Uhr",
    "Freitag 8.00-15.00 Uhr",
    "Mittagessen:",
    "Montag-Freitag 11.30-13.30 Uhr"
  ]),
  Mensi(id: 118, name: "Mensa Academica", oeffnungszeitenalles: [
    "Mensa:",
    "Montag-Freitag 11.00-14.00 Uhr",
    "Cafeteria:",
    "Montag-Freitag8.30-15.00 Uhr"
  ]),
  Mensi(id: 115, name: "Mensa am Elsterbecken", oeffnungszeitenalles: [
    "Mensa:",
    "Montag-Freitag 11.00-14.00 Uhr",
    "Cafeteria:",
    "Montag-Donnerstag	09.00-17.00 Uhr",
    "Freitag 09.00-15.00 Uhr",
    "Kaffeeinsel im OG:",
    "Montag-Freitag:	11.00-14.00 Uhr"
  ]),
  Mensi(id: 162, name: "Mensa am Medizincampus", oeffnungszeitenalles: [
    "Mensa:",
    "Montag-Freitag 10.45-14.00 Uhr",
    "Cafeteria:",
    "Montag-Freitag 08.00-15.00 Uhr"
  ]),
  Mensi(id: 106, name: "Mensa am Park", oeffnungszeitenalles: [
    "Montag-Donnerstag: 10.45-18.30 Uhr",
    "Freitag: 10.45-14.00 Uhr",
    "Samstag: 11.00-14.00 Uhr"
  ]),
  Mensi(id: 111, name: "Mensa Peterssteinweg", oeffnungszeitenalles: [
    "Mensa:",
    "Montag-Freitag	11.00-14.00 Uhr",
    "Cafeteria:",
    "Montag-Freitag	11.00-14.00 Uhr"
  ]),
  Mensi(id: 170, name: "Mensa Tierklinik", oeffnungszeitenalles: [
    "Mensa:",
    "Montag-Freitag 11.00-14.00 Uhr",
    "Cafeteria:",
    "Montag-Donnerstag	7.30-14.15 Uhr",
    "Freitag	7.30-14.00 Uhr"
  ]),
  Mensi(id: 127, name: "Mensaria am Botanischen Garten", oeffnungszeitenalles: [
    "Mensa:",
    "Montag-Freitag	11.00-14.00 Uhr",
    "Cafeteria:",
    "Montag-Freitag	09.00-14.00 Uhr"
  ]),
  Mensi(id: 140, name: "Mensa Schönauer Straße", oeffnungszeitenalles: [
    "Montag-Freitag	8.30-15.45 Uhr",
    "Mittagessen:",
    "Montag-Freitag	11.30-14.00 Uhr"
  ]),
];

class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({super.key, required this.mensipara});
  final Mensi mensipara;
  @override
  State<MyNavigationDrawer> createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
  @override
  void initState() {
    super.initState();
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 218, 179, 97),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        children: const [
          Image(image: AssetImage("assets/images/applogo512.png"), width: 80),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "MensiMates",
              style: TextStyle(fontFamily: "Open Sans", fontSize: 19),
            ),
          )
        ],
      ),
    );
  }

  Widget buildMensiItems(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("Home"),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomeScreenWidget()));
            },
          ),
          const Divider(color: Colors.grey),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            child: ListView.builder(
                itemCount: mensenliste.length,
                itemBuilder: ((context, index) {
                  final mensi = mensenliste[index];
                  return ListTile(
                    leading: const Icon(Icons.food_bank_outlined),
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
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text("About"),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AboutPage()));
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context),
            buildMensiItems(context),
          ],
        ),
      ),
    );
  }
}
