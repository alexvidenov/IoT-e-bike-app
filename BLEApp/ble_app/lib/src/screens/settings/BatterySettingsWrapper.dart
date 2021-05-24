import 'package:ble_app/src/blocs/IsSuperBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/ForbiddenPage.dart';
import 'package:ble_app/src/screens/settings/BatterySettings.dart';
import 'package:flutter/material.dart';

class BatterySettingsWrapper extends StatelessWidget {
  final Stream<bool> _authorizedToAccessParams;

  const BatterySettingsWrapper(this._authorizedToAccessParams);

  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
      stream: this._authorizedToAccessParams,
      initialData: false,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return snapshot.data == true
              ? BatterySettingsScreen($(), $())
              : ForbiddenPage();
        } else
          return Container();
      });
}
