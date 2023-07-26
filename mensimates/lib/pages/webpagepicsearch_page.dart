import "package:flutter/material.dart";
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../entities/dish_class.dart';
import '../utils/methods.dart';

class WebPageSearch extends StatefulWidget {
  const WebPageSearch({super.key, required this.searchDish});

  final Dish searchDish;

  @override
  State<WebPageSearch> createState() => _WebPageSearchState();
}

class _WebPageSearchState extends State<WebPageSearch> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google-Picture-Search"),
        centerTitle: true,
        backgroundColor: decideContainerColor(widget.searchDish.category),
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                  url: Uri.parse(
                      'https://www.google.com/search?q=${widget.searchDish.name}&tbm=isch')),
            ),
          ),
        ],
      ),
    );
  }
}
