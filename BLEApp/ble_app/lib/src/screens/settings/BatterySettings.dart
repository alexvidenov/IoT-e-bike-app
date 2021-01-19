import 'package:ble_app/src/blocs/ParameterListenerBloc.dart';
import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// P0000 - OK

// W27_newPINHERE - OK

class _CardParameter extends StatelessWidget {
  final int _index;
  final String _parameterName;
  final num _parameterValue;
  final String _measureUnit;
  final String _description;
  final Function _onTap;

  const _CardParameter(this._index, this._parameterName, this._parameterValue,
      this._description, this._measureUnit, this._onTap);

  @override
  Widget build(BuildContext context) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            ListTile(
                leading: Text(_index.toString()),
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('$_parameterName :'),
                      Text('$_parameterValue $_measureUnit')
                      // here check with smt like: prefs.maxCellVoltage ?? 24.
                    ]),
                subtitle: Text(_description),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: _onTap),
          ],
        ),
      );
}

class BatterySettingsScreen extends StatefulWidget {
  final ParameterListenerBloc _parameterListenerBloc;
  final SettingsBloc _settingsBloc;
  final BluetoothAuthBloc
      _authBloc; // FIXME try to abstract the bloc with only the necessary part
  final DeviceRepository _repository;

  BatterySettingsScreen(this._parameterListenerBloc, this._settingsBloc,
      this._authBloc, this._repository);

  @override
  _BatterySettingsScreenState createState() => _BatterySettingsScreenState();
}

class _BatterySettingsScreenState extends State<BatterySettingsScreen> {
  final _writeController = TextEditingController();

  @override
  initState() {
    super.initState();
    widget._authBloc.create();
    widget._parameterListenerBloc.create();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Battery Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
        stream: widget._parameterListenerBloc.parameters,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _CardParameter(
                    0,
                    'Cell Num',
                    snapshot.data['00'] ?? 4,
                    'Number of active cells',
                    '',
                    () => _presentDialog(context,
                        parameterKey: '00', action: 'Change')),
                _CardParameter(
                    1,
                    'V Max',
                    snapshot.data['01'] ?? 4.28,
                    'Max cell voltage',
                    'V',
                    () => _presentDialog(context,
                        parameterKey: '01', action: 'Change')),
                _CardParameter(
                    2,
                    'V MaxR',
                    snapshot.data['02'] ?? 4.15,
                    'Max recovery voltage',
                    'V',
                    () => _presentDialog(context,
                        parameterKey: '02', action: 'Change')),
                _CardParameter(
                    3,
                    'V Bal',
                    snapshot.data['03'] ?? 4.20,
                    'Balance cell voltage',
                    'V',
                    () => _presentDialog(context,
                        parameterKey: '03', action: 'Change')),
                _CardParameter(
                    4,
                    'VMin',
                    snapshot.data['04'] ?? 2.80,
                    'Min cell voltage',
                    'V',
                    () => _presentDialog(context,
                        parameterKey: '04', action: 'Change')),
                _CardParameter(
                    5,
                    'VMinR',
                    snapshot.data['05'] ?? 3.10,
                    'Min cell recovery voltage',
                    'V',
                    () => _presentDialog(context,
                        parameterKey: '05', action: 'Change')),
                _CardParameter(
                    6,
                    'VULOW',
                    snapshot.data['06'] ?? 2,
                    'Ultra low cell voltage',
                    'V',
                    () => _presentDialog(context,
                        parameterKey: '06', action: 'Change')),
                _CardParameter(
                    7,
                    'IDMax1',
                    snapshot.data['12'] ?? 20,
                    'Max limited discharge current',
                    'A',
                    () => _presentDialog(context,
                        parameterKey: '12', action: 'Change')),
                _CardParameter(
                    8,
                    'IDMax2',
                    snapshot.data['13'] ?? 25,
                    'Max cut-off discharge current',
                    'A',
                    () => _presentDialog(context,
                        parameterKey: '13', action: 'Change')),
                _CardParameter(
                    9,
                    'Id max 1 time',
                    snapshot.data['14'] ?? 10,
                    'Max current time-limit period',
                    's',
                    () => _presentDialog(context,
                        parameterKey: '14', action: 'Change')),
                _CardParameter(
                    10,
                    'ICMax',
                    snapshot.data['15'] ?? 8,
                    'Max cut-off charge current',
                    'A',
                    () => _presentDialog(context,
                        parameterKey: '15', action: 'Change')),
                _CardParameter(
                    11,
                    'I Thr Count',
                    snapshot.data['16'] ?? 40,
                    'Moto-hours current threshold',
                    'A',
                    () => _presentDialog(context,
                        parameterKey: '16', action: 'Change')),
                _CardParameter(
                    12,
                    'I Max c-off Time ',
                    snapshot.data['17'] ?? 5,
                    'Max cut-off time period',
                    's',
                    () => _presentDialog(context,
                        parameterKey: '17', action: 'Change')),
                _CardParameter(
                    13,
                    'T Max',
                    snapshot.data['23'] ?? 240,
                    'Max temperature cut-off',
                    '°C',
                    () => _presentDialog(context,
                        parameterKey: '23', action: 'Change')),
                _CardParameter(
                    15,
                    'T MaxR',
                    snapshot.data['24'] ?? 530,
                    'Max temperature recovery ',
                    '°C',
                    () => _presentDialog(context,
                        parameterKey: '24', action: 'Change')),
                _CardParameter(
                    16,
                    'T Min',
                    snapshot.data['25'] ?? 2480,
                    'Min temperature cut-off',
                    '°C',
                    () => _presentDialog(context,
                        parameterKey: '25', action: 'Change')),
                _CardParameter(
                    17,
                    'T MinR',
                    snapshot.data['26'] ?? 1680,
                    'Min temperature recovery',
                    '°C',
                    () => _presentDialog(context,
                        parameterKey: '26', action: 'Change')),
              ],
            );
          } else
            return Container();
        },
      )));

  Future<void> _presentDialog(BuildContext widgetContext,
      {String parameterKey, String action, int commaIndex}) async {
    await showDialog(
      context: widgetContext,
      builder: (context) => AlertDialog(
        title: Text('Enter new value'),
        content: TextField(
          controller: _writeController,
          //onChanged: (text) => _writeController.text += ',',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(action),
            onPressed: () async {
              String value;
              String controllerValue = _writeController.value.text;
              widget._repository.cancel();
              switch (controllerValue.length) {
                case 1:
                  value = '000$controllerValue';
                  break;
                case 2:
                  value = '00$controllerValue';
                  break;
                case 3:
                  value = '0$controllerValue';
                  break;
                case 4:
                  value = controllerValue;
              }
              print('INPUT FROM SETTINGS IS ' + 'W$parameterKey$value\r');
              Future.delayed(
                  Duration(milliseconds: 150), // works perfectly with 80.
                  () => widget
                      ._parameterListenerBloc // TODO:  After the first symbol, add comma with the bloc
                      .changeParameter('W$parameterKey$value\r'));
              Future.delayed(Duration(milliseconds: 80),
                  () => widget._repository.resume());
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
