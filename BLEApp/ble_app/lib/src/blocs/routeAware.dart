part of bloc;

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

// TODO: actually have the lifecycle methods extended with lifecycle delegate here

// ignore: must_be_immutable
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
