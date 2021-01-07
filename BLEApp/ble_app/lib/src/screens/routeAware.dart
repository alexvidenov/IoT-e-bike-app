import 'package:ble_app/src/blocs/bloc.dart';
import 'package:flutter/material.dart';

import 'Entrypoints/AuthStateListener.dart';

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

abstract class RouteAwareWidget<T extends Bloc> extends StatefulWidget {
  Widget buildWidget(BuildContext context);

  final T bloc;

  onCreate() {}

  onPause() {}

  onResume() {}

  onDestroy() {}

  const RouteAwareWidget({@required this.bloc});

  @override
  _RouteAwareWidgetState createState() => _RouteAwareWidgetState();
}

class _RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {
  @override
  initState() {
    super.initState();
    widget.bloc.create();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    // null check needed for the entry screen when we don't have context.
    if (route != null) routeObserver.subscribe(this, route);
    widget.onCreate();
  }

  @override
  didPush() {
    super.didPush();
    widget.bloc.resume();
    widget.onResume();
  }

  @override
  didPushNext() {
    super.didPushNext();
    widget.bloc.pause();
    widget.onPause();
  }

  @override
  didPop() {
    super.didPop();
    widget.bloc.dispose();
  }

  @override
  didPopNext() {
    super.didPopNext();
    widget.bloc.resume();
    widget.onResume();
  }

  @override
  dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
    widget.bloc.dispose();
    widget.onDestroy();
  }

  @override
  Widget build(BuildContext context) => widget.buildWidget(context);
}
