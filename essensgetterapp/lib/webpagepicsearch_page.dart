import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports

class WebPageSearch extends StatefulWidget {
  const WebPageSearch({super.key, required this.searchString});
  final String searchString;

  @override
  State<WebPageSearch> createState() => _WebPageSearchState();
}

class _WebPageSearchState extends State<WebPageSearch> {
  late WebViewController controllerWeb;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Google-Picture-Search"), centerTitle: true),
        body: WebViewWidget(controller: controllerWeb));
  }
}
