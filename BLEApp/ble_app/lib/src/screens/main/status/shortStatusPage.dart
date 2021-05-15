import 'package:ble_app/src/blocs/location/locationBloc.dart';
import 'package:ble_app/src/screens/base/BaseStatusPage.dart';
import 'package:flutter/material.dart';

import 'package:ble_app/src/blocs/status/shortStatusBloc.dart';
import 'package:ble_app/src/widgets/ShortStatusUI/ShortStatusWidget.dart';

class DeviceScreen extends BaseStatusPage {
  final LocationBloc locationBloc;
  final ShortStatusBloc shortStatusBloc;

  const DeviceScreen(this.shortStatusBloc, this.locationBloc);

  @override
  Widget buildContent(BuildContext context) => Container(
        child: ShortStatusUI(shortStatusBloc, locationBloc),
      );
}
