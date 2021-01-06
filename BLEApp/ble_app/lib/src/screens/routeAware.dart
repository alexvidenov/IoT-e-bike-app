import 'package:ble_app/src/blocs/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ble_app/src/screens/home.dart';

abstract class RouteAwareWidget<T extends Bloc> extends StatefulWidget {
  Widget buildWidget(BuildContext context);

  final T bloc;

  void onCreate() {}

  void onPause() {}

  void onResume() {}

  void onDestroy() {}

  const RouteAwareWidget({@required this.bloc});

  @override
  _RouteAwareWidgetState createState() => _RouteAwareWidgetState();
}

class _RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware{
  @override
  void initState() {
    super.initState();
    widget.bloc.create();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    // null check needed for the entry screen when we don't have context.
    if (route != null) routeObserver.subscribe(this, route);
    widget.onCreate();
  }

  @override
  void didPush() {
    super.didPush();
    widget.bloc.resume();
    widget.onResume();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    widget.bloc.pause();
    widget.onPause();
  }

  @override
  void didPop() {
    super.didPop();
    widget.bloc.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    widget.bloc.resume();
    widget.onResume();
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
    widget.bloc.dispose();
    widget.onDestroy();
  }

  @override
  Widget build(BuildContext context) => widget.buildWidget(context);
}
