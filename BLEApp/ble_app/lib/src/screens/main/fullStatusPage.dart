import 'package:ble_app/src/blocs/InnerPageManager.dart';
import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/blocs/navigationBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/navigationAware.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/widgets/FullStatusUI/VoltagesBarChart.dart';
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
        transitionDuration: const Duration(seconds: 1));
  }
}

class FullStatusScreen extends RouteAwareWidget<FullStatusBloc>
    with RouteUtils {
  const FullStatusScreen(FullStatusBloc fullStatusBloc)
      : super(bloc: fullStatusBloc);

  @override
  Widget buildWidget(BuildContext context) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity > 0) {
          $<InnerPageManager>().openShortStatus();
        } else if (details.primaryVelocity < 0) {
          $<InnerPageManager>().openMap();
        }
      },
      onTap: () => $<InnerPageManager>().openMap(),
      child: VoltagesBarChart(super.bloc));

  @override
  onResume() {
    super.onResume();
    notifyForRoute(CurrentPage.FullStatus);
  }
}
