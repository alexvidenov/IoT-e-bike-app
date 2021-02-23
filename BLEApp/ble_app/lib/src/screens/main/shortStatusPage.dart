import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ble_app/src/blocs/PageManager.dart';
import 'package:ble_app/src/screens/navigationAware.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:flutter/material.dart';

import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/ShortStatusWidget.dart';

class DeviceScreen extends RouteAwareWidget<ShortStatusBloc> with RouteUtils {
  // TODO: make RouteUtils an extension of routeAware widgets
  const DeviceScreen(ShortStatusBloc shortStatusBloc)
      : super(
            bloc: shortStatusBloc,
            key: const PageStorageKey('ShortStatusScreen'));

  @override
  Widget buildWidget(BuildContext context) {
    AwesomeDialog dialog;
    return GestureDetector(
      onTap: () => {}, // SEND NOTIFICATIONS TO HOME
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
