import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text("Info-Screen"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 10, 10, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "MensiApp",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontFamily: "Open Sans",
                                              color: const Color.fromARGB(
                                                  255, 36, 234, 10),
                                              fontSize: 30,
                                              letterSpacing: 2,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Diese App wurde entwickelt von Fritz Schubert in Zusammenarbeit mit dem Seemann Ole Einar Christoph und seinem Programm 'Essensgetter 2.0'. Vielen Dank bei der Einrichtung der vollständigen Funktionalität.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontFamily: "Open Sans",
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              fontSize: 14,
                                              letterSpacing: 2,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Viel Spaß",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontFamily: "Open Sans",
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              fontSize: 15,
                                              letterSpacing: 2,
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "🥰 Ich freue mich über jeden Verbesserungsvorschlag.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontFamily: "Open Sans",
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0),
                                              fontSize: 14,
                                              letterSpacing: 2,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () => showLicensePage(
                                            context: context,
                                            applicationName: "MensiApp",
                                            applicationVersion:
                                                "App Version: 1.0",
                                            applicationLegalese:
                                                "2023 MensiApp \u00a9 by Fritz Schubert",
                                            applicationIcon: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Image.asset(
                                                "assets/images/applogo512.png",
                                                width: 48,
                                                height: 48,
                                              ),
                                            )),
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Lizensen"),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          launch(
                                              "https://1drv.ms/b/s!Ama40oa14DIW4H4oYALQpCb1gfJB?e=saHE21");
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Impressum"),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          launch(
                                              "https://1drv.ms/b/s!Ama40oa14DIW4QAPEPZZy55vigQ9?e=lS9GUF");
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Datenschutzerklärung"),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text("Alle Angaben ohne Gewähr",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontFamily: "Open Sans",
                                                  fontSize: 15)),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: const [Text("2023 MensiApp \u00a9 by Fritz Schubert")],
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
