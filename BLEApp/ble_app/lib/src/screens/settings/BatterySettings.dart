import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/mixins/parameterAware/ParameterHolder.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/model/DeviceRepository.dart';
import 'package:ble_app/src/modules/dataClasses/deviceParametersModel.dart';
import 'package:flutter/material.dart';

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
  final ParameterHolder
      _holder; //  change it to a stream from some bloc (the parameter change)
  final SettingsBloc _settingsBloc;
  final BluetoothAuthBloc _authBloc;
  final DeviceRepository _repository;

  const BatterySettingsScreen(
      this._holder, this._repository, this._settingsBloc, this._authBloc);

  @override
  _BatterySettingsScreenState createState() => _BatterySettingsScreenState();
}

class _BatterySettingsScreenState extends State<BatterySettingsScreen> {
  final _writeController = TextEditingController();

  bool _isAuthenticated = false;

  _retry() => Future.delayed(Duration(seconds: 2), () {
        // see the time if corrections are needed
        if (_isAuthenticated == false) _resetSession();
      });

  _resetSession() => widget._repository.writeToCharacteristic(
      (widget._settingsBloc.getPassword() ??
              widget._settingsBloc.password.value) +
          '\r');

  _listenToAuthBloc() => widget._authBloc.stream.listen((event) {
        event.when(
            bTAuthenticated: () {
              _isAuthenticated = true;
              widget._repository.writeToCharacteristic(
                  _writeController.value.text + '\r'); // will sen
              // Future.delayed(3 seconds) => isAuthenticated = false needs to be reset// d only when authenticated
            },
            bTNotAuthenticated: (reason) => {});
      });

  @override
  initState() {
    super.initState();
    widget._authBloc.create();
    _listenToAuthBloc();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Battery Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
          child: StreamBuilder<DeviceParametersModel>(
        stream: widget._holder.stream,
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
                    () => _presentDialog(context, action: 'Change')),
                _CardParameter(
                    1,
                    'V Max',
                    snapshot.data.maxCellVoltage ?? 4.28,
                    'Max cell voltage',
                    'V',
                    () => _presentDialog(context, action: 'Change')),
                _CardParameter(
                    2,
                    'V MaxR',
                    snapshot.data.maxRecoveryVoltage ?? 4.15,
                    'Max recovery voltage',
                    'V',
                    () => _presentDialog(context, action: 'Change')),
                _CardParameter(
                    3,
                    'V Bal',
                    snapshot.data.balanceCellVoltage ?? 4.20,
                    'Balance cell voltage',
                    'V',
                    () => _presentDialog(context, action: 'Change')),
                _CardParameter(
                    4,
                    'VMin',
                    snapshot.data.minCellVoltage ?? 2.80,
                    'Min cell voltage',
                    'V',
                    () => _presentDialog(context, action: 'Change')),
                _CardParameter(
                    5,
                    'VMinR',
                    snapshot.data.minCellRecoveryVoltage ?? 3.10,
                    'Min cell recovery voltage',
                    'V',
                    () => _presentDialog(context, action: 'Change')),
                _CardParameter(
                    6,
                    'VULOW',
                    snapshot.data.ultraLowCellVoltage ?? 2,
                    'Ultra low cell voltage',
                    'V',
                    () => _presentDialog(context, action: 'Change')),
                _CardParameter(
                    7,
                    'IDMax1',
                    snapshot.data.maxTimeLimitedDischargeCurrent ?? 20,
                    'Max limited discharge current',
                    'A',
                    () => _presentDialog(context, action: 'Change')),
                _CardParameter(
                    8,
                    'IDMax2',
                    snapshot.data.maxCutoffDischargeCurrent ?? 25,
                    'Max cut-off discharge current',
                    'A',
                    () => _presentDialog(context, action: 'Change')),
                _CardParameter(
                    8,
                    'Id max 1 time',
                    snapshot.data.maxCurrentTimeLimitPeriod ?? 10,
                    'Max current time-limit period',
                    's',
                    () => _presentDialog(context, action: 'Change')),
                _CardParameter(
                    10,
                    'ICMax',
                    snapshot.data.maxCutoffChargeCurrent ?? 8,
                    'Max cut-off charge current',
                    'A',
                    () => _presentDialog(context, action: 'Change')),
                _CardParameter(
                    11,
                    'I Thr Count',
                    snapshot.data?.motoHoursCounterCurrentThreshold ?? 40,
                    'Moto-hours current threshold',
                    'A',
                    () => _presentDialog(context, action: 'Change')),
                _CardParameter(
                    12,
                    'I Max c-off Time ',
                    snapshot.data.currentCutOffTimerPeriod ?? 5,
                    'Max cut-off time period',
                    's',
                    () => _presentDialog(context, action: 'Change')),
                _CardParameter(
                    13,
                    'T Max',
                    snapshot.data.maxCutoffTemperature ?? 240,
                    'Max temperature cut-off',
                    '°C',
                    () => _presentDialog(context, action: 'Change')),
                _CardParameter(
                    15,
                    'T MaxR',
                    snapshot.data.maxTemperatureRecovery ?? 530,
                    'Max temperature recovery ',
                    '°C',
                    () => _presentDialog(context, action: 'Change')),
                _CardParameter(
                    16,
                    'T Min',
                    snapshot.data.minCutoffTemperature ?? 2480,
                    'Min temperature cut-off',
                    '°C',
                    () => _presentDialog(context, action: 'Change')),
                _CardParameter(
                    17,
                    'T MinR',
                    snapshot.data.minTemperatureRecovery ?? 1680,
                    'Min temperature recovery',
                    '°C',
                    () => _presentDialog(context, action: 'Change')),
              ],
            );
          } else
            return Container();
        },
      )));

  Future<void> _presentDialog(BuildContext widgetContext,
      {String message, String action}) async {
    // TODO: inject the R + 01/ whatever and the parameter value, also try to restrain it in a given number of symbols
    await showDialog(
      context: widgetContext,
      builder: (context) => AlertDialog(
        title: Text('Enter new value'),
        content: TextField(
          controller: _writeController,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(action),
            onPressed: () {
              //_resetSession();
              //_retry();
              widget._repository
                  .writeToCharacteristic(_writeController.value.text + '\r');
              //widget._holder.addEvent() // this add event will be called once the parameters is actually got through a stream listen
              // (prolly a new bloc specifically for that)¬
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
