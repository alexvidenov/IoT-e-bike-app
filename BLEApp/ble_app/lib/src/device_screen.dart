import 'dart:async';
import 'dart:convert' show utf8;
import 'package:ble_app/src/blocs/btConnectionBloc.dart';
import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/widgets.dart';
import 'package:ble_app/src/widgets/progressBars.dart';
import 'package:ble_app/src/widgets/topBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({Key key, this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final String SERVICE_UUID =
      "0000ffe0-0000-1000-8000-00805f9b34fb"; // for HM-10
  final String CHARACTERISTIC_UUID = "0000ffe1-0000-1000-8000-00805f9b34fb";

  BluetoothCharacteristic bluetoothCharacteristic;
  bool isReady = false;
  String value = ""; // will be updated every packet
  String curValue = ""; // which will be appended to
  int counter = 0;

  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
  }

  listenToCharacteristic(BluetoothCharacteristic characteristic) {
    characteristic.value.listen((event) {
      // event is List<int>
      if (event.length != 0) {
        if (event.contains(10)) {
          for (int i = 0; i < event.length; i++) {
            if (event.elementAt(i) == 10) {
              value = curValue;
              context.bloc<ShortStatusBloc>().add(value);
              curValue = "";
            } else {
              List<int> curList = [event.elementAt(i)];
              curValue += _dataParser(curList);
            } //the problem was that I wasn't updating curValue after passing the '\n' in the packet
          }
        } else {
          curValue += _dataParser(event);
        }
      }
    });
  }

  periodicWriteToCharacteristic() {
    new Timer.periodic(Duration(milliseconds: 500), (Timer t) {
      writeData("S");
    });
  }

  connectToDevice() async {
    if (widget.device == null) {
      //context.bloc<ConnectionBloc>().add(ConnectionEvent.FailedToConnect);
      return;
    }

    context.bloc<ConnectionBloc>().add(ConnectionEvent.Connected);
    //context.bloc<ConnectionBloc>().add(ConnectionEvent.Connecting);

    //new Timer(const Duration(seconds: 15), () {
    //if (!isReady) {
    //disconnectFromDevice();
    //_Pop();
    //}
    //});

    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice() {
    if (widget.device == null) {
      _Pop();
      return;
    }

    widget.device.disconnect();
  }

  discoverServices() async {
    if (widget.device == null) {
      //context.bloc<ConnectionBloc>().add(ConnectionEvent.FailedToConnect);
    }

    List<BluetoothService> services = await widget.device.discoverServices();
    await widget.device.requestMtu(512);
    for (BluetoothService service in services) {
      if (service.uuid.toString() == SERVICE_UUID) {
        for (BluetoothCharacteristic characteristic
            in service.characteristics) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            characteristic.setNotifyValue(true);
            bluetoothCharacteristic = characteristic;
            //listenToCharacteristic(bluetoothCharacteristic);
            //periodicWriteToCharacteristic();
            isReady = true;
            context.bloc<ConnectionBloc>().add(ConnectionEvent.Connected);
          }
        }
      }
    }

    if (!isReady) {
      _Pop();
    }
  }

  _Pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  writeData(String data) {
    if (bluetoothCharacteristic == null) return;

    List<int> bytes = utf8.encode(data);
    bluetoothCharacteristic.write(bytes);
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to disconnect device and go back?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No')),
                FlatButton(
                    onPressed: () {
                      disconnectFromDevice();
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Yes')),
              ],
            ) ??
            false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Device Screen'),
        ),
        body: Container(
          child: BlocBuilder<ConnectionBloc, ConnectionEvent>(
            builder: (_, state) {
              switch (state) {
                case ConnectionEvent.Connected:
                  //return TestWidget();
                  return Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              TopBar(),
                              Positioned(
                                top: 20.0,
                                left: 0.0,
                                right: 0.0,
                                child: Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          'Parameters',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0,
                                              color: Colors.white,
                                              letterSpacing: 1.2),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_ios,
                                            color: Colors.white,
                                            size: 35.0,
                                          ),
                                          onPressed:
                                              () {}, // later on this will move to the previous page
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            'Ble app',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24.0,
                                                color: Colors.white,
                                                letterSpacing: 1.2),
                                          ),
                                          Text(
                                            'Short status',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24.0,
                                                color: Colors.white,
                                                letterSpacing: 1.2),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(
                                          'Full status page',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24.0,
                                              color: Colors.white,
                                              letterSpacing: 1.2),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 35.0,
                                          ),
                                          onPressed:
                                              () {}, // later on this will move to the next page
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ), // here ends the top nav
                          SleekCircularSlider(
                            appearance: appearance01,
                            min: 0.00,
                            max: 80.00,
                            initialValue:
                                50, // will fetch data from gps eventually
                          ),
                          CurrentRow(),
                          //Divider(),
                          // uncomment to test communication
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: ProgressRows(), // this will be the Consumer
                          ),
                          // here goes the horizontal progress bar (or two of them)
                        ],
                      ),
                    ],
                  );
                case ConnectionEvent.Connecting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionEvent.FailedToConnect:
                  _Pop();
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
