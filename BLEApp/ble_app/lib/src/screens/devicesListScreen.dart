import 'dart:async';

import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/devicesBloc.dart';
import 'package:ble_app/src/data/BleDevice.dart';
import 'package:ble_app/src/data/DeviceRepository.dart';
import 'package:ble_app/src/screens/authenticationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:provider/provider.dart';

typedef DeviceTapListener = void Function();

class DevicesListScreen extends StatefulWidget {
  @override
  State<DevicesListScreen> createState() => DeviceListScreenState();
}

class DeviceListScreenState extends State<DevicesListScreen> {
  DevicesBloc _devicesBloc;
  StreamSubscription _appStateSubscription;
  bool _shouldRunOnResume = true;

  void _onPause() {
    _appStateSubscription.cancel();
    _devicesBloc.dispose();
  }

  void _onResume() {
    _devicesBloc.init();
    _appStateSubscription = _devicesBloc.pickedDevice.listen((bleDevice) async {
      _onPause();
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Provider(
              create: (_) => DeviceBloc(DeviceRepository(), BleManager()),
              child: AuthenticationScreen(),
            ),
          ));
      setState(() {
        _shouldRunOnResume = true;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_devicesBloc == null) {
      _devicesBloc = Provider.of<DevicesBloc>(context);
      if (_shouldRunOnResume) {
        _shouldRunOnResume = false;
        _onResume();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldRunOnResume) {
      _shouldRunOnResume = false;
      _onResume();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth devices'),
      ),
      body: StreamBuilder<List<BleDevice>>(
        initialData: _devicesBloc.visibleDevices.value,
        stream: _devicesBloc.visibleDevices,
        builder: (context, snapshot) => RefreshIndicator(
          onRefresh: _devicesBloc.refresh,
          child: DevicesList(_devicesBloc, snapshot.data),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _onPause();
    super.dispose();
  }
}

class DevicesList extends ListView {
  DevicesList(DevicesBloc devicesBloc, List<BleDevice> devices)
      : super.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  height: 0,
                  indent: 0,
                ),
            itemCount: devices.length,
            itemBuilder: (context, i) {
              return _buildRow(context, devices[i],
                  _createTapListener(devicesBloc, devices[i]));
            });

  static DeviceTapListener _createTapListener(
      DevicesBloc devicesBloc, BleDevice bleDevice) {
    return () => devicesBloc.devicePicker.add(bleDevice);
  }

  static Widget _buildAvatar(BuildContext context, BleDevice device) {
    return CircleAvatar(
        child: Icon(Icons.bluetooth),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white);
  }

  static Widget _buildRow(BuildContext context, BleDevice device,
      DeviceTapListener deviceTapListener) {
    return ListTile(
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
}
