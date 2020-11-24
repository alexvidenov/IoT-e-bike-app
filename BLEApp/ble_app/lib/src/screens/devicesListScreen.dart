import 'dart:async';

import 'package:ble_app/src/blocs/devicesBloc.dart';
import 'package:ble_app/src/model/BleDevice.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:flutter/material.dart';

typedef _DeviceTapListener = void Function();

// ignore: must_be_immutable
class DevicesListScreen extends RouteAwareWidget {
  final DevicesBloc _devicesBloc;
  StreamSubscription _pickedDevicesSubscription;

  DevicesListScreen(DevicesBloc devicesBloc)
      : this._devicesBloc = devicesBloc,
        super(bloc: devicesBloc);

  _listenForPickedDevice(BuildContext context) =>
      _pickedDevicesSubscription = _devicesBloc.pickedDevice.listen((_) {
        this.onPause();
        Navigator.of(context)
            .pushNamed('/auth'); // this route does not exist lmao
      });

  @override
  Widget buildWidget(BuildContext context) {
    _listenForPickedDevice(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth devices'),
      ),
      body: StreamBuilder<List<BleDevice>>(
        initialData: _devicesBloc.visibleDevices.value,
        stream: _devicesBloc.visibleDevices,
        builder: (_, snapshot) => RefreshIndicator(
          onRefresh: _devicesBloc.refresh,
          child: _DevicesList(_devicesBloc, snapshot.data),
        ),
      ),
    );
  }

  @override
  void onPause() {
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
      () => devicesBloc.addEvent(bleDevice);

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
