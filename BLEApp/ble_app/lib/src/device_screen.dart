import 'dart:async';
import 'dart:convert' show utf8;
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({Key key, this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  final String SERVICE_UUID = "0000ffe0-0000-1000-8000-00805f9b34fb"; // for HM-10
  final String CHARACTERISTIC_UUID = "0000ffe1-0000-1000-8000-00805f9b34fb";
  BluetoothCharacteristic bluetoothCharacteristic;
  bool isReady;
  Stream<List<int>> dataStream;
  String value;

  @override
  void initState(){ 
    super.initState();
    isReady = false;
    connectToDevice();
  }

  connectToDevice() async {
    if(widget.device == null){
      _Pop();
      return;
    }

    new Timer(const Duration(seconds: 15), () {
      if(!isReady){
        disconnectFromDevice();
        _Pop();
      }
    });

    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice(){
    if(widget.device == null){
       _Pop();
      return;
    }

    widget.device.disconnect();
  }

  discoverServices() async{
    if(widget.device == null){
       _Pop();
      return;
    }

    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) {
      if(service.uuid.toString() == SERVICE_UUID){
        service.characteristics.forEach((characteristic) {
          if(characteristic.uuid.toString() == CHARACTERISTIC_UUID){
            characteristic.setNotifyValue(!characteristic.isNotifying);
            bluetoothCharacteristic = characteristic;
            dataStream = characteristic.value; 
            writeData("Gatt connected");
            setState(() {
              isReady = true;
            });
          }
        });
      }
    });

    if(!isReady){
      _Pop();
    }
  }

  _Pop(){
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice){
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
            new AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to disconnect device and go back?'),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No')),
                new FlatButton(
                    onPressed: () {
                      disconnectFromDevice();
                      Navigator.of(context).pop(true);
                    },
                    child: new Text('Yes')),
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
            child: !isReady
                ? Center(
                    child: Text(
                      "Waiting...",
                      style: TextStyle(fontSize: 24, color: Colors.red),
                    ),
                  )
                : Container(
                    child: StreamBuilder<List<int>>(
                      stream: dataStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<int>> snapshot) {
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');

                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          var currentValue = _dataParser(snapshot.data);

                          return Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Current value read: ',
                                          style: TextStyle(fontSize: 14)),
                                      Text('$currentValue',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24))
                                    ]),
                              ),
                            ],
                          ));
                        } else {
                          return Text('Something went wrong with the stream');
                        }
                      },
                    ),
                  )),
      ),
    );
  }
}
