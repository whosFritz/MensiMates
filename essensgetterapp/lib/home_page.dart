import 'package:flutter/material.dart';

import 'mensi_schedule.dart';
import 'navigation_drawer.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text("Home"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
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
        ));
  }
}
