import "package:flutter/material.dart";
import 'package:package_info_plus/package_info_plus.dart';
import "package:url_launcher/url_launcher.dart";

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Title(
      color: Colors.black,
      title: 'About',
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: const Text('Info-Screen'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: GestureDetector(
            child: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final packageInfo = snapshot.data!;
                  final version = packageInfo.version;
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'MensiMates',
                            style: TextStyle(
                              color: Color.fromARGB(255, 36, 234, 10),
                              fontFamily: 'Open Sans',
                              fontSize: 30,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            launchUrl(Uri.parse(
                                'https://projectmensimates.whosfritz.de'));
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Projekt-Webseite'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Version: $version',
                            style: const TextStyle(
                              fontFamily: 'Open Sans',
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                              "Diese App wurde entwickelt von Fritz Schubert in Zusammenarbeit mit Ole Einar Christoph und seinem Projekt 'MensaHub'. Vielen Dank bei der Einrichtung der vollständigen Funktionalität. Schaut gerne auf seinem Github vorbei und abonniert den MensaHub Newsletter.",
                              style: TextStyle(
                                  fontFamily: "Open Sans",
                                  color: Colors.black,
                                  letterSpacing: 2,
                                  fontSize: 14)),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Viel Spaß",
                            style: TextStyle(
                              fontFamily: "Open Sans",
                              color: Colors.black,
                              letterSpacing: 2,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "🥰 Ich freue mich über jeden Verbesserungsvorschlag. 😘",
                            style: TextStyle(
                                fontFamily: "Open Sans",
                                color: Colors.black,
                                letterSpacing: 2,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Durch Nutzung der App stimmst du zu, dass deine anonyme Bewertung der Gerichte für statistische Zwecke und nichtkommerzielle Zwecke benutzt werden.",
                            style: TextStyle(
                                fontFamily: "Open Sans",
                                color: Colors.black,
                                letterSpacing: 2,
                                fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextButton(
                            onPressed: () => showLicensePage(
                                context: context,
                                applicationName: "MensiMates",
                                applicationVersion: version,
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
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text("Alle Angaben ohne Gewähr.",
                              style: TextStyle(
                                  fontFamily: "Open Sans",
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 8),
                                  child: Text(
                                      "\u00a9 2023 MensiMates by Fritz Schubert"),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
