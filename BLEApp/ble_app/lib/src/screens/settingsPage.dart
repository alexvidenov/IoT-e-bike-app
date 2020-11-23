import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  final DeviceRepository deviceRepository = DeviceRepository();
  final SettingsBloc settingsBloc = locator<SettingsBloc>();

  final _writeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.lock_outline, color: Colors.black),
                    title: Text("Change password"),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => _presentDialog(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text("Device Settings: ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                )),
            StreamBuilder<bool>(
                stream: settingsBloc.deviceExists,
                initialData: settingsBloc.isDeviceRemembered(),
                builder: (context, snapshot) {
                  return SwitchListTile(
                    contentPadding: EdgeInsets.all(0),
                    activeColor: Colors.lightBlueAccent,
                    value: snapshot.data,
                    title: Text("Remember this device"),
                    onChanged: (value) {
                      value == true
                          ? settingsBloc.saveDeviceId(
                              deviceRepository.pickedDevice.value.id)
                          : settingsBloc.removeDeviceId();
                    },
                  );
                }),
            StreamBuilder<bool>(
                stream: settingsBloc.deviceExists,
                initialData: settingsBloc.isDeviceRemembered(),
                builder: (_, snapshot) {
                  if (snapshot.data == false) {
                    return SwitchListTile(
                      contentPadding: EdgeInsets.all(0),
                      activeColor: Colors.lightBlueAccent,
                      value: false,
                      title: Text("Remember my password"),
                      onChanged: null,
                    );
                  } else {
                    return StreamBuilder<bool>(
                        stream: settingsBloc.passwordExists,
                        initialData: settingsBloc.isPasswordRemembered(),
                        builder: (context, snapshot) {
                          return SwitchListTile(
                              contentPadding: EdgeInsets.all(0),
                              activeColor: Colors.lightBlueAccent,
                              value: snapshot.data,
                              title: Text("Remember my password"),
                              onChanged: (value) {
                                value == true
                                    ? settingsBloc.savePassword(
                                        settingsBloc.password.value)
                                    : settingsBloc.removePassword();
                              });
                        });
                  }
                }),
          ],
        ),
      ),
    );
  }

  Future<void> _presentDialog(BuildContext widgetContext) async {
    await showDialog(
      context: widgetContext,
      builder: (context) {
        return AlertDialog(
          title: Text("Change your password"),
          content: TextField(
            controller: _writeController,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Confirm"),
              onPressed: () {
                locator<BluetoothAuthBloc>()
                    .changePassword(_writeController.value.text);
                settingsBloc.setPassword(_writeController.value.text);
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }
}
