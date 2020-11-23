import 'package:ble_app/src/blocs/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ble_app/src/screens/home.dart';

abstract class RouteAwareWidget<T extends Bloc> extends StatefulWidget {
  Widget buildWidget(BuildContext context);

  final T bloc;

  void onResume() {}

  const RouteAwareWidget({@required this.bloc});

  @override
  _RouteAwareWidgetState createState() => _RouteAwareWidgetState();
}

class _RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {
  @override
  void initState() {
    super.initState();
    widget.bloc.create();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
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
    widget.bloc.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  Widget build(BuildContext context) => widget.buildWidget(context);
}
