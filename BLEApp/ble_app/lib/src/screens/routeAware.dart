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

  const RouteAwareWidget({@required this.bloc, PageStorageKey key})
      : super(key: key);

  @override
  RouteAwareWidgetState createState() => RouteAwareWidgetState();
}

class RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {
  @override
  void initState() {
    super.initState();
    widget.bloc.create();
    widget.onCreate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    // null check needed for the entry screen when we don't have Modal route context.
    if (route != null) routeObserver.subscribe(this, route);
  }

  @override
  void didPush() {
    super.didPush();
    widget.bloc.resume();
    widget.onResume();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    widget.bloc.pause();
    widget.onPause();
    widget.onDestroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.buildWidget(context);
  }
}

@optionalTypeArgs
abstract class MapRouteAwareWidget<T extends Bloc> extends StatefulWidget {
  Widget buildWidget(BuildContext context);

  final T bloc;

  onCreate() {}

  onPause() {}

  onResume() {}

  onDestroy() {}

  const MapRouteAwareWidget({@required this.bloc, PageStorageKey key})
      : super(key: key);

  @override
  MapRouteAwareWidgetState createState() => MapRouteAwareWidgetState();
}

class MapRouteAwareWidgetState extends State<MapRouteAwareWidget>
    with RouteAware, AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    widget.bloc.create();
    widget.onCreate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    // null check needed for the entry screen when we don't have Modal route context.
    if (route != null) routeObserver.subscribe(this, route);
  }

  @override
  void didPush() {
    super.didPush();
    widget.bloc.resume();
    widget.onResume();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    widget.bloc.pause();
    widget.onPause();
    widget.onDestroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.buildWidget(context);
  }

  @override
  bool get wantKeepAlive => true;
}
