import 'package:flutter/material.dart';

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

abstract class RouteLifecycleAwareWidget extends StatefulWidget {
  Widget buildWidget(BuildContext context);

  void onCreate() {}

  void onPause() {}

  void onResume() {}

  void onDestroy() {}

  void didUpdate() {}

  const RouteLifecycleAwareWidget();

  @override
  RouteLifecycleAwareWidgetState createState() =>
      RouteLifecycleAwareWidgetState();
}

class RouteLifecycleAwareWidgetState<T extends RouteLifecycleAwareWidget>
    extends State<T> with RouteAware {
  @override
  initState() {
    super.initState();
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
    widget.onResume();
    print('DID PUSH');
  }

  @override
  didPushNext() {
    super.didPushNext();
    widget.onPause();
  }

  @override
  didPopNext() {
    super.didPopNext();
    print('DID POP NEXT');
    widget.onResume();
  }

  @override
  dispose() {
    routeObserver.unsubscribe(this);
    widget.onDestroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.buildWidget(context);
}
