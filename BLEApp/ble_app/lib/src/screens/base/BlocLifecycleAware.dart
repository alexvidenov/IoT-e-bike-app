import 'package:ble_app/src/blocs/base/bloc.dart';
import 'package:ble_app/src/screens/base/RouteLifecycleAware.dart';
import 'package:flutter/material.dart';

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

@optionalTypeArgs
abstract class BlocLifecycleAwareKeepAliveWidget<T extends Bloc>
    extends BlocLifecycleAwareWidget<T> {
  const BlocLifecycleAwareKeepAliveWidget({@required T bloc})
      : super(bloc: bloc);

  @override
  RouteLifecycleAwareWidgetState createState() =>
      _BlocLifecycleAwareKeepAliveWidgetState();
}

class _BlocLifecycleAwareKeepAliveWidgetState
    extends RouteLifecycleAwareWidgetState<BlocLifecycleAwareKeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.buildWidget(context);
  }

  @override
  bool get wantKeepAlive => true;
}

@optionalTypeArgs
abstract class BlocLifecycleAwareWidget<T extends Bloc>
    extends RouteLifecycleAwareWidget {
  final T bloc;

  const BlocLifecycleAwareWidget({@required this.bloc});

  @override
  @mustCallSuper
  void onCreate() {
    super.onCreate();
    bloc.create();
  }

  @override
  @mustCallSuper
  void onPause() {
    super.onPause();
    bloc.pause();
  }

  @override
  @mustCallSuper
  void onResume() {
    super.onResume();
    bloc.resume();
  }

  @override
  @mustCallSuper
  void onDestroy() {
    super.onDestroy();
    bloc.dispose();
  }
}
