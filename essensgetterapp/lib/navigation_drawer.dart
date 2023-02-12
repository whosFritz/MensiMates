import 'package:essensgetterapp/aboutpage_widget.dart';
import 'package:essensgetterapp/home_page.dart';
import 'package:essensgetterapp/mensi_schedule.dart';
import 'package:flutter/material.dart';
import 'mensi_class.dart';

List<Mensi> mensenliste = [
  Mensi(id: 153, name: "Cafeteria Dittrichring"),
  Mensi(id: 118, name: "Mensa Academica"),
  Mensi(id: 115, name: "Mensa am Elsterbecken"),
  Mensi(id: 162, name: "Mensa am Medizincampus"),
  Mensi(id: 106, name: "Mensa am Park"),
  Mensi(id: 111, name: "Mensa Peterssteinweg"),
  Mensi(id: 170, name: "Mensa Tierklinik"),
  Mensi(id: 127, name: "Mensaria am Botanischen Garten"),
  Mensi(id: 140, name: "Mensa Schönauer Straße"),
];

class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({super.key});

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
        children: [
          const Image(
              image: AssetImage("assets/images/applogo512.png"), width: 80),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "MensiMates",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontFamily: "Open Sans", fontSize: 19),
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
                                mensiID: mensi.id,
                                mensiName: mensi.name,
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
