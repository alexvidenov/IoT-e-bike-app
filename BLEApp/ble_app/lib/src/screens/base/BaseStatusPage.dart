import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ble_app/src/blocs/PageManager.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/base/KeepAliveWidget.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/ShortStatusWidget.dart';
import 'package:flutter/material.dart';

abstract class BaseStatusPage extends KeepAliveWidget {
  final VoidCallback onTap;

  const BaseStatusPage({this.onTap});

  @override
  Widget buildWidget(BuildContext context) {
    AwesomeDialog dialog;
    return GestureDetector(
        onTap: onTap,
        child: NotificationListener<ServiceNotification>(
          onNotification: (notification) {
            if (notification.isStateGone) {
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => dialog?.dissmiss());
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                dialog = AwesomeDialog(
                    context: $<PageManager>().context,
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
          child: buildContent(context),
        ));
  }

  Widget buildContent(BuildContext context);
}
