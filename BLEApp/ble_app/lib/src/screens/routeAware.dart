import 'package:ble_app/src/blocs/bloc.dart';
import 'package:flutter/material.dart';

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

@optionalTypeArgs
abstract class RouteAwareWidget<T extends Bloc> extends StatefulWidget {
  Widget buildWidget(BuildContext context);

  final T bloc;

  onCreate() {}

  onPause() {}

  onResume() {}

  onDestroy() {}

  didUpdate() {}

  const RouteAwareWidget({@required this.bloc});

  @override
  _RouteAwareWidgetState createState() => _RouteAwareWidgetState();
}

class _RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {
  @override
  initState() {
    super.initState();
    widget.bloc.create();
    widget.onCreate();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    // null check needed for the entry screen when we don't have Modal route context.
    if (route != null) routeObserver.subscribe(this, route);
    print('DID CHANGE DEPS');
    widget.didUpdate();
  }

  @override
  didPush() {
    super.didPush();
    widget.bloc.resume();
    widget.onResume();
    print('DID PUSH');
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
    print('DID POP NEXT');
    widget.bloc.resume();
    widget.onResume();
  }

  @override
  dispose() {
    routeObserver.unsubscribe(this);
    widget.bloc.dispose();
    widget.onDestroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.buildWidget(context);
}