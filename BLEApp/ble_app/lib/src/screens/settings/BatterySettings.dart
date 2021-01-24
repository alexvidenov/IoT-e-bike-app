import 'package:ble_app/src/blocs/parameterListenerBloc.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:flutter/material.dart';

// P0000 - OK

// W27_newPINHERE - OK

// Cell count
// W0001 - first node (first to get info from master) if(ostatuk == 1) else substract a from the  second
// W0002 - second node

typedef ChangeParameterCallback = Future<void> Function(String, String);

class _CardParameter extends StatelessWidget {
  final int _showcaseIndex;
  final String _tableIndex;
  final String _parameterName;
  final num _parameterValue;
  final String _measureUnit;
  final String _description;
  final ChangeParameterCallback _onTap;

  const _CardParameter(
      this._showcaseIndex,
      this._tableIndex,
      this._parameterName,
      this._parameterValue,
      this._description,
      this._measureUnit,
      this._onTap);

  @override
  Widget build(BuildContext context) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            ListTile(
                leading: Text(_showcaseIndex.toString()),
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                          '$_parameterName :',
                          style: TextStyle(fontSize: 24, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: TextEditingController.fromValue(
                              // instantiate a controller here i guess?
                              TextEditingValue(text: '$_parameterValue')),
                          onFieldSubmitted: (value) {
                            _onTap(_tableIndex,
                                value); // ADD SUCCESSFUL ALERT TO THE UI
                          },
                          onChanged: (value) => print('Changed to $value'),
                        ),
                      ),
                      Text(
                        '$_measureUnit',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      // here check with smt like: prefs.maxCellVoltage ?? 24.
                    ]),
                subtitle: Text(_description),
                trailing: Icon(Icons.keyboard_arrow_right)),
          ],
        ),
      );
}

class BatterySettingsScreen extends RouteAwareWidget<ParameterListenerBloc> {
  final ParameterListenerBloc _parameterListenerBloc;
  final DeviceRepository _repository;

  const BatterySettingsScreen(
      ParameterListenerBloc parameterListenerBloc, this._repository)
      : this._parameterListenerBloc = parameterListenerBloc,
        super(bloc: parameterListenerBloc);

  Future<void> completion(String key, String value) async {
    _repository.cancel();
    await Future.delayed(
        Duration(milliseconds: 150), // works perfectly with 80.
        () => _parameterListenerBloc.changeParameter(key, value));
    Future.delayed(Duration(milliseconds: 80), () => _repository.resume());
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: const Text('Battery Settings'),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
            child: StreamBuilder<DeviceParameters>(
          stream: _parameterListenerBloc.parameters,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _CardParameter(
                      0,
                      '00',
                      'Cell Num',
                      snapshot.data.cellCount ?? 4,
                      'Number of active cells',
                      '',
                      completion),
                  _CardParameter(
                      1,
                      '01',
                      'V Max',
                      (snapshot.data.maxCellVoltage) ?? 4.28,
                      'Max cell voltage',
                      'V',
                      completion),
                  _CardParameter(
                      2,
                      '02',
                      'V MaxR',
                      (snapshot.data.maxRecoveryVoltage) ?? 4.15,
                      'Max recovery voltage',
                      'V',
                      completion),
                  _CardParameter(
                      3,
                      '03',
                      'V Bal',
                      (snapshot.data.balanceCellVoltage) ?? 4.20,
                      'Balance cell voltage',
                      'V',
                      completion),
                  _CardParameter(
                      4,
                      '04',
                      'VMin',
                      (snapshot.data.minCellVoltage) ?? 2.80,
                      'Min cell voltage',
                      'V',
                      completion),
                  _CardParameter(
                      5,
                      '05',
                      'VMinR',
                      (snapshot.data.minCellRecoveryVoltage) ?? 3.10,
                      'Min cell recovery voltage',
                      'V',
                      completion),
                  _CardParameter(
                      6,
                      '06',
                      'VULOW',
                      (snapshot.data.ultraLowCellVoltage) ?? 2,
                      'Ultra low cell voltage',
                      'V',
                      completion),
                  _CardParameter(
                      7,
                      '12',
                      'IDMax1',
                      (snapshot.data.maxTimeLimitedDischargeCurrent) ?? 20,
                      'Max limited discharge current',
                      'A',
                      completion),
                  _CardParameter(
                      8,
                      '13',
                      'IDMax2',
                      (snapshot.data.maxCutoffDischargeCurrent) ?? 25,
                      'Max cut-off discharge current',
                      'A',
                      completion),
                  _CardParameter(
                      9,
                      '14',
                      'Id max 1 time',
                      snapshot.data.maxCurrentTimeLimitPeriod ?? 10,
                      'Max current time-limit period',
                      's',
                      completion),
                  _CardParameter(
                      10,
                      '15',
                      'ICMax',
                      (snapshot.data.maxCutoffChargeCurrent) ?? 8,
                      'Max cut-off charge current',
                      'A',
                      completion),
                  _CardParameter(
                      11,
                      '16',
                      'I Thr Count',
                      (snapshot.data.motoHoursCounterCurrentThreshold) ?? 40,
                      'Moto-hours current threshold',
                      'A',
                      completion),
                  _CardParameter(
                      12,
                      '17',
                      'I Max c-off Time ',
                      snapshot.data.currentCutOffTimerPeriod ?? 5,
                      'Max cut-off time period',
                      's',
                      completion),
                  _CardParameter(
                      13,
                      '23',
                      'T Max',
                      (snapshot.data.maxCutoffTemperature) ?? 240,
                      'Max temperature cut-off',
                      '°C',
                      completion),
                  _CardParameter(
                      14,
                      '24',
                      'T MaxR',
                      snapshot.data.maxTemperatureRecovery ?? 530,
                      'Max temperature recovery ',
                      '°C',
                      completion),
                  _CardParameter(
                      15,
                      '25',
                      'T MinR',
                      snapshot.data.minTemperatureRecovery ?? 1680,
                      'Min temperature recovery',
                      '°C',
                      completion),
                  _CardParameter(
                      16,
                      '26',
                      'T Min',
                      snapshot.data.minCutoffTemperature ?? 2480,
                      'Min temperature cut-off',
                      '°C',
                      completion),
                ],
              );
            } else
              return Container();
          },
        )));
  }
}
