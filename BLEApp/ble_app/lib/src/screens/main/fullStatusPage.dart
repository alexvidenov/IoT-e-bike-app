import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ble_app/src/blocs/PageManager.dart';
import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/sealedStates/BatteryState.dart';
import 'package:ble_app/src/widgets/FullStatusUI/VoltagesBarChart.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/ShortStatusWidget.dart';
import 'package:flutter/material.dart';

class FullStatusScreen extends StatefulWidget {
  final FullStatusBloc fullStatusBloc;

  const FullStatusScreen(this.fullStatusBloc);

  @override
  _FullStatusScreenState createState() => _FullStatusScreenState();
}

class _FullStatusScreenState extends State<FullStatusScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    AwesomeDialog dialog;
    return GestureDetector(
        onTap: () => {}, // TODO: notifications to home
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
          child: VoltagesBarChart(this.widget.fullStatusBloc),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
