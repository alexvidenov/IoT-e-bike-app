import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ble_app/src/blocs/InnerPageManager.dart';
import 'package:ble_app/src/blocs/PageManager.dart';
import 'package:ble_app/src/screens/navigationAware.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
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
  Widget buildWidget(BuildContext context) {
    AwesomeDialog dialog;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity > 0) {
        } else if (details.primaryVelocity < 0) {
          $<InnerPageManager>().openFullStatus();
        }
      },
      onTap: () => $<InnerPageManager>().openFullStatus(),
      child: NotificationListener<ServiceNotification>(
        onNotification: (notification) {
          if (notification.isStateGone) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => dialog.dissmiss());
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
                  dismissOnBackKeyPress: true,
                  dismissOnTouchOutside: true);
              dialog.show();
            });
          }
          return true;
        },
        child: Container(
          child: ShortStatusUI(super.bloc, $()),
        ),
      ),
    );
  }

  @override
  onResume() {
    super.onResume();
    notifyForRoute(CurrentPage.ShortStatus);
  }
}
