import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/screens/base/BaseSettingScreen.dart';
import 'package:flutter/material.dart';

class DeviceSettingsScreen extends BaseSettingScreen {
  final _passwordController = TextEditingController();
  final _editDeviceNameController = TextEditingController();

  DeviceSettingsScreen() : super(title: "Device settings");

  @override
  Widget buildContent(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.lock_outline, color: Colors.black),
                  title: Text("Change password"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => _presentDialog(context),
                ),
                const SizedBox(
                  height: 30,
                ),
                ListTile(
                  leading: Icon(Icons.lock_outline, color: Colors.black),
                  title: Text("Change device name"),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () => _renameDevice(context),
                ),
              ],
            ),
          ),
        ],
      );

  Future<void> _presentDialog(BuildContext widgetContext) async {
    await showDialog(
      context: widgetContext,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter new password"),
          content: TextField(
            controller: _passwordController,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Confirm"),
              onPressed: () {
                deviceRepository.cancel();
                bluetoothAuthBloc.changePassword(
                    _passwordController.value.text); // should wait for 'OK'
                Future.delayed(Duration(milliseconds: 80),
                    () => deviceRepository.resume());
                settingsBloc.setPassword(_passwordController.value.text);
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _renameDevice(BuildContext widgetContext) async {
    await showDialog(
      context: widgetContext,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter your new device name"),
          content: TextField(
            controller: _editDeviceNameController,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Confirm"),
              onPressed: () {
                deviceRepository.cancel();
                bluetoothAuthBloc
                    .changeDeviceName(_editDeviceNameController.value.text);
                Future.delayed(Duration(milliseconds: 80),
                    () => deviceRepository.resume());
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }
}
