import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ble_app/src/blocs/InnerPageManager.dart';
import 'package:ble_app/src/blocs/PageManager.dart';
import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/navigationAware.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/widgets/FullStatusUI/VoltagesBarChart.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/ShortStatusWidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FullStatusPage extends Page {
  final Widget child;

  FullStatusPage({@required this.child, Key key}) : super(key: key);

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
        settings: this,
        pageBuilder: (_, animation, __) {
          return SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(1, 0), end: const Offset(0, 0))
                .animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500));
  }
}

class FullStatusScreen extends RouteAwareWidget<
        FullStatusBloc> // add another abstraction here that will have gesture detector and the notification setup
    with
        RouteUtils {
  const FullStatusScreen(FullStatusBloc fullStatusBloc)
      : super(bloc: fullStatusBloc);

  @override
  Widget buildWidget(BuildContext context) {
    AwesomeDialog dialog;
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity > 0) {
            $<InnerPageManager>().openShortStatus();
          } else if (details.primaryVelocity < 0) {
            $<InnerPageManager>().openMap();
          }
        },
        onTap: () => $<InnerPageManager>().openMap(),
        child: NotificationListener<ServiceNotification>(
          onNotification: (notification) {
            if (notification.isStateGone) {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => dialog?.dissmiss());
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                dialog = AwesomeDialog(
                    context: $<PageManager>().navigatorKey.currentState.context,
                    useRootNavigator: true,
                    dialogType: DialogType.WARNING,
                    headerAnimationLoop: false,
                    customHeader: FlareHeader(
                      loop: false,
                      dialogType: DialogType.WARNING,
                    ),
                    animType: AnimType.TOPSLIDE,
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Service!',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.3),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          notification.state.string(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    dismissOnBackKeyPress: false,
                    dismissOnTouchOutside: true);
                dialog.show();
              });
            }
            return true;
          },
          child: VoltagesBarChart(super.bloc),
        ));
  }

  @override
  onResume() {
    super.onResume();
    notifyForRoute(CurrentPage.FullStatus);
  }
}
