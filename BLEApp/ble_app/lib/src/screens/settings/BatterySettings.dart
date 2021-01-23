import 'package:ble_app/src/blocs/parameterListenerBloc.dart';
import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:flutter/material.dart';

// P0000 - OK

// W27_newPINHERE - OK

// Cell count
// W0001 - first node (first to get info from master) if(ostatuk == 1) else substract a from the  second
// W0002 - second node
//

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
                      Text(
                        '$_parameterName :',
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      ),
                      Text(
                        '$_parameterValue $_measureUnit',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      )
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
  final SettingsBloc _settingsBloc; // won't be needed
  final BluetoothAuthBloc
      _authBloc; // FIXME try to abstract the bloc with only the necessary part
  final DeviceRepository _repository;

  const BatterySettingsScreen(this._parameterListenerBloc, this._settingsBloc,
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
        title: const Text('Battery Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
          child: StreamBuilder<DeviceParameters>(
        stream: widget._parameterListenerBloc.parameters,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _CardParameter(
                    0,
                    'Cell Num',
                    snapshot.data.cellCount ?? 4,
                    'Number of active cells',
                    '',
                    () => _presentDialog(context,
                        parameterKey: '00', action: 'Change')),
                _CardParameter(
                    1,
                    'V Max',
                    (snapshot.data.maxCellVoltage / 100) ?? 4.28,
                    'Max cell voltage',
                    'V',
                    () => _presentDialog(context,
                        parameterKey: '01', action: 'Change', commaIndex: 1)),
                _CardParameter(
                    2,
                    'V MaxR',
                    (snapshot.data.maxRecoveryVoltage / 100) ?? 4.15,
                    'Max recovery voltage',
                    'V',
                    () => _presentDialog(context,
                        parameterKey: '02', action: 'Change')),
                _CardParameter(
                    3,
                    'V Bal',
                    (snapshot.data.balanceCellVoltage / 100) ?? 4.20,
                    'Balance cell voltage',
                    'V',
                    () => _presentDialog(context,
                        parameterKey: '03', action: 'Change')),
                _CardParameter(
                    4,
                    'VMin',
                    (snapshot.data.minCellVoltage / 100) ?? 2.80,
                    'Min cell voltage',
                    'V',
                    () => _presentDialog(context,
                        parameterKey: '04', action: 'Change')),
                _CardParameter(
                    5,
                    'VMinR',
                    (snapshot.data.minCellRecoveryVoltage / 100) ?? 3.10,
                    'Min cell recovery voltage',
                    'V',
                    () => _presentDialog(context,
                        parameterKey: '05', action: 'Change')),
                _CardParameter(
                    6,
                    'VULOW',
                    (snapshot.data.ultraLowCellVoltage / 100) ?? 2,
                    'Ultra low cell voltage',
                    'V',
                    () => _presentDialog(context,
                        parameterKey: '06', action: 'Change')),
                _CardParameter(
                    7,
                    'IDMax1',
                    (snapshot.data.maxTimeLimitedDischargeCurrent / 100) ?? 20,
                    'Max limited discharge current',
                    'A',
                    () => _presentDialog(context,
                        parameterKey: '12', action: 'Change')),
                _CardParameter(
                    8,
                    'IDMax2',
                    (snapshot.data.maxCutoffDischargeCurrent / 100) ?? 25,
                    'Max cut-off discharge current',
                    'A',
                    () => _presentDialog(context,
                        parameterKey: '13', action: 'Change')),
                _CardParameter(
                    9,
                    'Id max 1 time',
                    snapshot.data.maxCurrentTimeLimitPeriod ?? 10,
                    'Max current time-limit period',
                    's',
                    () => _presentDialog(context,
                        parameterKey: '14', action: 'Change')),
                _CardParameter(
                    10,
                    'ICMax',
                    (snapshot.data.maxCutoffChargeCurrent / 100) ?? 8,
                    'Max cut-off charge current',
                    'A',
                    () => _presentDialog(context,
                        parameterKey: '15', action: 'Change')),
                _CardParameter(
                    11,
                    'I Thr Count',
                    (snapshot.data.motoHoursCounterCurrentThreshold / 100) ??
                        40,
                    'Moto-hours current threshold',
                    'A',
                    () => _presentDialog(context,
                        parameterKey: '16', action: 'Change')),
                _CardParameter(
                    12,
                    'I Max c-off Time ',
                    snapshot.data.currentCutOffTimerPeriod ?? 5,
                    'Max cut-off time period',
                    's',
                    () => _presentDialog(context,
                        parameterKey: '17', action: 'Change')),
                _CardParameter(
                    13,
                    'T Max',
                    (snapshot.data.maxCutoffTemperature) ?? 240,
                    'Max temperature cut-off',
                    '°C',
                    () => _presentDialog(context,
                        parameterKey: '23', action: 'Change')),
                _CardParameter(
                    15,
                    'T MaxR',
                    snapshot.data.maxTemperatureRecovery ?? 530,
                    'Max temperature recovery ',
                    '°C',
                    () => _presentDialog(context,
                        parameterKey: '24', action: 'Change')),
                _CardParameter(
                    16,
                    'T Min',
                    snapshot.data.minCutoffTemperature ?? 2480,
                    'Min temperature cut-off',
                    '°C',
                    () => _presentDialog(context,
                        parameterKey: '25', action: 'Change')),
                _CardParameter(
                    17,
                    'T MinR',
                    snapshot.data.minTemperatureRecovery ?? 1680,
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
        content: TextField(controller: _writeController
            /*
          onChanged: (text) {
            if (_writeController.text.length == commaIndex) {
              final oldControllerValue = _writeController.text;
              //_writeController.selection =
              final String newText = oldControllerValue + ',';
              final newControllerValue = _writeController.value.copyWith(
                  text: newText,
                  composing:
                      TextRange(start: 2, end: 3) //offset to Last Character
                  );
              _writeController.value = newControllerValue;
            }
          },
             */
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
              await Future.delayed(
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
