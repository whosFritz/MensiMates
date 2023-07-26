import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mensimates/pages/aboutpage_widget.dart';
import 'package:mensimates/pages/home_page.dart';
import 'package:mensimates/pages/mensi_schedule.dart';

import '../entities/mensi_class.dart';
import '../utils/variables.dart';

class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({super.key, required this.mensipara});

  final Mensi mensipara;

  @override
  State<MyNavigationDrawer> createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: CupertinoScrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildHeader(context),
              buildMensiItems(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 218, 179, 97),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: const Column(
        children: [
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
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: const Text("Home"),
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomeScreenWidget(
                      rateMyApp: rateMyApp2,
                    )));
          },
        ),
        const Divider(color: Colors.grey),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
          child: Column(
            children: [
              for (final mensi in mensenListe)
                ListTile(
                  leading: const Icon(Icons.food_bank_outlined),
                  title: Text(mensi.name),
                  onTap: () {
                    if (widget.mensipara.id == mensi.id) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MensiSchedule(
                                mensiObj: mensi,
                              )));
                    }
                  },
                )
            ],
          ),
        ),
        const Divider(color: Colors.grey),
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
    );
  }
}
