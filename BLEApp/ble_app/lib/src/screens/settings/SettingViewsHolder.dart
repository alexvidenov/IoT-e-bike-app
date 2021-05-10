import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/base/PageViewWidget.dart';
import 'package:ble_app/src/screens/settings/ConnectionSettingsScreen.dart';
import 'package:ble_app/src/screens/settings/DeviceSettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'BatterySettings.dart';

class SettingViewsHolder extends PageViewWidget {
  @override
  List<GButton> buildTabs() {
    return [
      GButton(
        gap: 8,
        icon: Icons.bluetooth,
        iconActiveColor: Colors.redAccent,
        iconColor: Colors.black,
        textColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        backgroundColor: Colors.greenAccent,
        text: 'Connection',
      ),
      GButton(
          gap: 8,
          icon: Icons.security,
          text: 'Device',
          iconActiveColor: Colors.redAccent,
          iconColor: Colors.black,
          textColor: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
          backgroundColor: Colors.lightBlue),
      GButton(
        gap: 8,
        icon: Icons.battery_charging_full_sharp,
        iconActiveColor: Colors.redAccent,
        iconColor: Colors.black,
        textColor: Colors.black,
        backgroundColor: Colors.yellow,
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        text: 'Battery',
      ),
    ];
  }

  @override
  List<Widget> get pages => [
        ConnectionSettingsScreen(),
        DeviceSettingsScreen(),
        BatterySettingsScreen($(), $()),
      ];
}
