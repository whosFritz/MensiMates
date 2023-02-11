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
                                        "MensiMates",
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
                                        "Diese App wurde entwickelt von Fritz Schubert in Zusammenarbeit mit dem Seemann Ole Einar Christoph und seinem Programm 'EssensGetter 2.0'. Vielen Dank bei der Einrichtung der vollständigen Funktionalität. Schaut gerne auf seinem Github vorbei und abonniert den EssensGetter Newsletter.",
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
                                        "🥰 Ich freue mich über jeden Verbesserungsvorschlag. 😘",
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Durch Nutzung der App stimmst du zu, dass deine anonyme Bewertung der Gerichte für statistische Zwecke und nichtkommerzielle Zwecke benutzt werden.",
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
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () => showLicensePage(
                                            context: context,
                                            applicationName: "MensiMates",
                                            applicationVersion:
                                                "Preview for Ole",
                                            applicationLegalese:
                                                "\u00a9 2023 MensiMates by Fritz Schubert",
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
                                          child: Text("Lizenzen"),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          launchUrl(Uri.parse(
                                              "https://github.com/whosFritz/Mensa-App/blob/master/impressum.md"));
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Impressum"),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          launchUrl(Uri.parse(
                                              "https://github.com/whosFritz/Mensa-App/blob/master/privacy-policy.md"));
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text("Datenschutzerklärung"),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Text("Alle Angaben ohne Gewähr.",
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
                    children: const [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                        child: Text("\u00a9 2023 MensiMates by Fritz Schubert"),
                      )
                    ],
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
