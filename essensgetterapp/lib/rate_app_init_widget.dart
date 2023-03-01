import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

late RateMyApp rateMyApp2;

class RateAppInitWidget extends StatefulWidget {
  final Widget Function(RateMyApp) builder;
  const RateAppInitWidget({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<RateAppInitWidget> createState() => _RateAppInitWidgetState();
}

class _RateAppInitWidgetState extends State<RateAppInitWidget> {
  RateMyApp? rateMyApp;

  static const playStoreId = "com.whosfritz.MensiMates";

  @override
  Widget build(BuildContext context) => RateMyAppBuilder(
        onInitialized: ((context, rateMyApp) {
          setState(() {
            this.rateMyApp = rateMyApp;
            rateMyApp2 = rateMyApp;
          });
        }),
        builder: (context) => rateMyApp == null
            ? const Center(child: CircularProgressIndicator())
            : widget.builder(rateMyApp!),
        rateMyApp: RateMyApp(googlePlayIdentifier: playStoreId),
      );
}
