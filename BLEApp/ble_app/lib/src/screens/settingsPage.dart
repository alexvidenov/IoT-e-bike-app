import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceBloc = GetIt.I<DeviceRepository>();
    final settingsBloc = GetIt.I<SettingsBloc>();
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
                    onTap: () =>
                        {}, // just show a dialog here and save in prefs the result
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
                          ? settingsBloc
                              .saveDeviceId(deviceBloc.pickedDevice.value.id)
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
}
