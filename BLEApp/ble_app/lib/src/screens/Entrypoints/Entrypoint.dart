import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

abstract class EntryPoint extends StatelessWidget {
  // TODO: make other routes entrypoints as well because of the MediaQueryz
  final Route<dynamic> Function(RouteSettings) onGenerateRoute;

  const EntryPoint({
    Key key,
    @required this.onGenerateRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        builder: (context, widget) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: ResponsiveWrapper.builder(widget,
              maxWidth: 1200,
              minWidth: 480,
              defaultScale: true,
              breakpoints: [
                ResponsiveBreakpoint.resize(480, name: MOBILE),
                ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ]),
        ),
        color: Colors.lightBlue,
        theme: ThemeData(fontFamily: 'Europe_Ext'),
        initialRoute: '/',
        onGenerateRoute: this.onGenerateRoute,
      );
}
