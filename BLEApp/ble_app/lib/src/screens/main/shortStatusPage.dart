import 'package:ble_app/src/blocs/InnerPageManager.dart';
import 'package:ble_app/src/screens/navigationAware.dart';
import 'package:flutter/material.dart';

import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/ShortStatusWidget.dart';

class ShortStatusPage extends Page {
  final Widget child;

  ShortStatusPage({@required this.child, Key key}) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
        settings: this,
        pageBuilder: (context, animation, _) {
          return SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(-1, 0), end: const Offset(0, 0))
                .animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500));
  }
}

class DeviceScreen extends RouteAwareWidget<ShortStatusBloc> with RouteUtils {
  // TODO: make RouteUtils an extension of routeAware widgets
  const DeviceScreen(ShortStatusBloc shortStatusBloc)
      : super(bloc: shortStatusBloc);

  @override
  Widget buildWidget(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity > 0) {
          } else if (details.primaryVelocity < 0) {
            $<InnerPageManager>().openFullStatus();
          }
        },
        //onTap: () => $<InnerPageManager>().openFullStatus(),
        child: Container(
          child: ShortStatusUI(super.bloc, $()),
        ),
      );

  @override
  onResume() {
    super.onResume();
    //final context = navigationBloc.navigatorKey.currentContext;
    /*
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('HM'),
              content: Text('Test'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Test'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          });
    });
     */
    notifyForRoute(CurrentPage.ShortStatus);
    // TODO; optional => add an event for the outputs state
  }
}
