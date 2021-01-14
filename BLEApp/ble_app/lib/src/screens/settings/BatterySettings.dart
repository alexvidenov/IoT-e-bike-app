import 'package:ble_app/src/blocs/mixins/parameterAware/ParameterHolder.dart';
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
                onTap: _onTap // stuff
                ),
          ],
        ),
      );
}

class BatterySettingsScreen extends StatelessWidget {
  final ParameterHolder _holder;

  const BatterySettingsScreen(this._holder);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Battery Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _CardParameter(
                0,
                'Cell Num',
                _holder.deviceParameters?.cellCount ?? 4,
                'Number of active cells',
                '',
                () => {}),
            _CardParameter(
                1,
                'V Max',
                _holder.deviceParameters?.maxCellVoltage ?? 4.28,
                'Max cell voltage',
                'V',
                () => {}),
            _CardParameter(
                2,
                'V MaxR',
                _holder.deviceParameters?.maxRecoveryVoltage ?? 4.15,
                'Max recovery voltage',
                'V',
                () => {}),
            _CardParameter(
                3,
                'V Bal',
                _holder.deviceParameters?.balanceCellVoltage ?? 4.20,
                'Balance cell voltage',
                'V',
                () => {}),
            _CardParameter(
                4,
                'VMin',
                _holder.deviceParameters?.minCellVoltage ?? 2.80,
                'Min cell voltage',
                'V',
                () => {}),
            _CardParameter(
                5,
                'VMinR',
                _holder.deviceParameters?.minCellRecoveryVoltage ?? 3.10,
                'Min cell recovery voltage',
                'V',
                () => {}),
            _CardParameter(
                6,
                'VULOW',
                _holder.deviceParameters?.ultraLowCellVoltage ?? 2,
                'Ultra low cell voltage',
                'V',
                () => {}),
            _CardParameter(
                7,
                'IDMax1',
                _holder.deviceParameters?.maxTimeLimitedDischargeCurrent ?? 20,
                'Max limited discharge current',
                'A',
                () => {}),
            _CardParameter(
                8,
                'IDMax2',
                _holder.deviceParameters?.maxCutoffDischargeCurrent ?? 25,
                'Max cut-off discharge current',
                'A',
                () => {}),
            _CardParameter(
                8,
                'Id max 1 time',
                _holder.deviceParameters?.maxCurrentTimeLimitPeriod ?? 10,
                'Max current time-limit period',
                's',
                () => {}),
            _CardParameter(
                10,
                'ICMax',
                _holder.deviceParameters?.maxCutoffChargeCurrent ?? 8,
                'Max cut-off charge current',
                'A',
                () => {}),
            _CardParameter(
                11,
                'I Thr Count',
                _holder.deviceParameters?.motoHoursCounterCurrentThreshold ?? 40,
                'Moto-hours current threshold',
                'A',
                () => {}),
            _CardParameter(
                12,
                'I Max c-off Time ',
                _holder.deviceParameters?.currentCutOffTimerPeriod ?? 5,
                'Max cut-off time period',
                's',
                () => {}),
            _CardParameter(
                13,
                'T Max',
                _holder.deviceParameters?.maxCutoffTemperature ?? 240,
                'Max temperature cut-off',
                '°C',
                () => {}),
            _CardParameter(
                15,
                'T MaxR',
                _holder.deviceParameters?.maxTemperatureRecovery ?? 530,
                'Max temperature recovery ',
                '°C',
                () => {}),
            _CardParameter(
                16,
                'T Min',
                _holder.deviceParameters?.minCutoffTemperature ?? 2480,
                'Min temperature cut-off',
                '°C',
                () => {}),
            _CardParameter(
                17,
                'T MinR',
                _holder.deviceParameters?.minTemperatureRecovery ?? 1680,
                'Min temperature recovery',
                '°C',
                () => {}),
          ],
        ),
      ));
}
