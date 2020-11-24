import 'package:flutter/material.dart';

abstract class EntryPoint extends StatelessWidget {
  final Route<dynamic> Function(RouteSettings) onGenerateRoute;

  const EntryPoint({
    Key key,
    @required this.onGenerateRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        color: Colors.lightBlue,
        theme: ThemeData(fontFamily: 'Europe_Ext'),
        initialRoute: '/',
        onGenerateRoute: this.onGenerateRoute,
      );
}
