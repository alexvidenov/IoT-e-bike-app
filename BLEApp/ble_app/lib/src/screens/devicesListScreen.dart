import 'dart:async';

import 'package:ble_app/src/blocs/devicesBloc.dart';
import 'package:ble_app/src/model/BleDevice.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart' as locationPerm;
import 'package:location/location.dart';

typedef _DeviceTapListener = void Function();

typedef _LogOutListener = Future<void> Function();

// ignore: must_be_immutable
class DevicesListScreen extends RouteAwareWidget<DevicesBloc> {
  final DevicesBloc _devicesBloc;
  final _LogOutListener _onLogout;
  StreamSubscription _pickedDevicesSubscription;

  DevicesListScreen(DevicesBloc devicesBloc, this._onLogout)
      : this._devicesBloc = devicesBloc,
        super(bloc: devicesBloc);

  _listenForPickedDevice(BuildContext context) =>
      // TODO instead of this, have one stream with multiple states
      _pickedDevicesSubscription = _devicesBloc.pickedDevice.listen((_) {
        this.onPause();
        Navigator.of(context).pushNamed('/auth');
      });

  @override
  onCreate() async {
    super.onCreate();
    locationPerm.PermissionStatus permissionStatus =
        await locationPerm.LocationPermissions().checkPermissionStatus();
    if (permissionStatus != locationPerm.PermissionStatus.granted) {
      await locationPerm.LocationPermissions().requestPermissions();
    } else if (!await Location().serviceEnabled()) {
      Location().requestService();
    }
  }

  @override
  Widget buildWidget(BuildContext context) {
    _listenForPickedDevice(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth devices'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                      onTap: () async => await _onLogout())),
              PopupMenuItem(
                  child: ListTile(
                      leading: Icon(Icons.create), title: Text('Add device')))
              // This will open modal bottom sheet
            ],
          )
        ],
      ),
      body: StreamBuilder<List<BleDevice>>(
        initialData: _devicesBloc.visibleDevices.value,
        stream: _devicesBloc.visibleDevices,
        builder: (_, snapshot) => RefreshIndicator(
          onRefresh: _devicesBloc.refresh,
          child: _DevicesList(_devicesBloc, snapshot.data),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () => _devicesBloc.refresh(),
      ),
    );
  }

  @override
  onPause() {
    super.onPause();
    _pickedDevicesSubscription.cancel();
  }
}

class _DevicesList extends ListView {
  _DevicesList(DevicesBloc devicesBloc, List<BleDevice> devices)
      : super.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  height: 0,
                  indent: 0,
                ),
            itemCount: devices.length,
            itemBuilder: (context, i) => _buildRow(context, devices[i],
                _createTapListener(devicesBloc, devices[i])));

  static _DeviceTapListener _createTapListener(
          DevicesBloc devicesBloc, BleDevice bleDevice) =>
      () => devicesBloc.addEvent(
          bleDevice); // TODO: addEvent(DevicesListEvent.device(bleDevice)

  static Widget _buildAvatar(BuildContext context, BleDevice device) =>
      CircleAvatar(
          child: Icon(Icons.bluetooth),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white);

  static Widget _buildRow(BuildContext context, BleDevice device,
          _DeviceTapListener deviceTapListener) =>
      ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: _buildAvatar(context, device),
        ),
        title: Text(device.name),
        trailing: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Icon(Icons.chevron_right, color: Colors.grey),
        ),
        subtitle: Column(
          children: <Widget>[
            Text(
              device.id.toString(),
              style: TextStyle(fontSize: 10),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        onTap: deviceTapListener,
        contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 12),
      );
}
