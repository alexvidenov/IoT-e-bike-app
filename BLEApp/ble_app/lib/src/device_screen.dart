import 'dart:async';
import 'dart:convert' show utf8;
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:ble_app/src/utils.dart';

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
  final _writeController = TextEditingController();
  bool isReady;
  //Stream<List<int>> dataStream;
  String value = "";
  //String curValue = ""; // which will be appended to

  @override
  void initState() { 
    super.initState();
    isReady = false;
    connectToDevice();
  }   

  listenToCharacteristic(BluetoothCharacteristic characteristic){
    characteristic.value.listen((event) {
      if(event.length != 0){
        setState(() {
          value += _dataParser(event);
        });
        //value += _dataParser(event);
        //if(event.last == 10){
         // curValue += _dataParser(event);
         // setState(() {
         //   value = curValue;
         //   curValue = "";
        //  });
       // }
       // else{
         // curValue += _dataParser(event);
       // }
      }
    });
  }

  connectToDevice() async {
    if(widget.device == null){
      _Pop();
      return;
    }

    //new Timer(const Duration(seconds: 20), () {
     // if(!isReady){
      //  disconnectFromDevice();
      //  _Pop();
    //  }
   // });

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

  discoverServices() async {
    if(widget.device == null){
       _Pop();
      return;
    }

    List<BluetoothService> services = await widget.device.discoverServices();
    await widget.device.requestMtu(512);
    for(BluetoothService service in services){
      if(service.uuid.toString() == SERVICE_UUID){
        for(BluetoothCharacteristic characteristic in service.characteristics){
          if(characteristic.uuid.toString() == CHARACTERISTIC_UUID){
            characteristic.setNotifyValue(true);
            bluetoothCharacteristic = characteristic;
            listenToCharacteristic(bluetoothCharacteristic);
            //dataStream = characteristic.value; 
            //writeData("Abcdefghijklmnopq");
            //setState(() {
              isReady = true;
            //});
          }
        }
      }
    }

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
            child: //!isReady ? 
                //Center(
                    //child: Text(
                      //"Waiting...",
                      //style: TextStyle(fontSize: 24, color: Colors.red),
                    //),
                 // )
              //  :
                Container(
                    //child: StreamBuilder<List<int>>(
                      //stream: dataStream,
                      //builder: (BuildContext context,
                          //AsyncSnapshot<List<int>> snapshot) {
                        //if (snapshot.hasError)
                          //return Text('Error: ${snapshot.error}');

                       // if (snapshot.connectionState ==
                           // ConnectionState.active) {

                              //String string = _dataParser(snapshot.data);
                
                          //  if(snapshot.data.length != 0){ // bad state exception..
                           //   if(snapshot.data.last != 33){  // received the whole packet
                             //  curValue += _dataParser(snapshot.data);
                               //curValue += _dataParser(snapshot.data);
                               //value = curValue;
                               //curValue = "";  // reset
                               //setState(() { });
                           //   }
                            //  else{ // received part of packet
                             //   curValue += _dataParser(snapshot.data);
                                //curValue += _dataParser(snapshot.data); 
                               // value = curValue;
                              //  print(value);
                               // curValue = "";
                                //setState(() {});
                             // }
                           // } 
                      child: Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Device MTU:' ,
                                        style: TextStyle(
                                          fontSize: 14
                                        )
                                      ),
                                      Text('$widget.device.mtu', style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24
                                          ) 
                                      ),
                                      Text('Current values read: ',
                                          style: TextStyle(fontSize: 14)),
                                      Text('$value',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24
                                          )
                                      ),
                                      RaisedButton(
                                        child: Text("Write"),
                                        onPressed: () async {
                                            await showDialog(
                                              context: context,
                                              builder: (BuildContext context){
                                                return AlertDialog(
                                                  title: Text("Write"),
                                                  content: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: TextField(
                                                          controller: _writeController,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text("Send"),
                                                      onPressed: () { 
                                                        writeData(_writeController.value.text);
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text("Cancel"),
                                                      onPressed: () {
                                                        Navigator.pop(context);           
                                                      },
                                                    ),
                                                  ],
                                                );
                                              }
                                            );
                                        },
                                      ),
                                     // SleekCircularSlider(
                                      //  appearance: appearance01,
                                      //  initialValue: 50 //int.parse(currentValue).toDouble(),
                                      //),      
                                    ]
                                  ),
                              ),
                            ],
                          ),
                        ),
                        //} else {
                         // return Text('Something went wrong with the stream');
                       // }
                    ),
                  )
                ),
    );
  }
}
