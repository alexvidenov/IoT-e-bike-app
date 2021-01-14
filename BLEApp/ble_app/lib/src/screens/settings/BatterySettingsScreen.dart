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
                0, 'Cell Num', 24, 'Number of active cells', '', () => {}),
            _CardParameter(1, 'V Max', 24, 'Max cell voltage', 'V', () => {}),
            _CardParameter(2, 'V MaxR', 24, 'Max recovery voltage', 'V', () => {}),
            _CardParameter(3, 'V Bal', 24, 'Balance activate voltage', 'V', () => {}),
            _CardParameter(4, 'VMin', 24, 'Min cell voltage', 'V', () => {}),
            _CardParameter(
                5, 'VMinR', 24, 'Min cell recovery voltage', 'V', () => {}),
            _CardParameter(
                6, 'VULOW', 24, 'Ultra low cell voltage', 'V', () => {}),
            _CardParameter(7, 'IDMax1', 24, 'Max limited discharge current',
                'A', () => {}),
            _CardParameter(8, 'IDMax2', 24, 'Max cut-off discharge voltage',
                'A', () => {}),
            _CardParameter(
                8, 'IDTMT', 24, 'Max current time-limit period', 's', () => {}),
            _CardParameter(9, 'ICMax', 24, 'Max cut-off charge', 'A', () => {}),
            _CardParameter(
                10, 'ITHr', 24, 'Moto-hours current threshold', 'A', () => {}),
            _CardParameter(11, 'CTM', 24, 'Max cut-off charge', 'A', () => {}),
            _CardParameter(12, 'CTM', 24, 'Max cut-off charge', 'A', () => {}),
            _CardParameter(13, 'TMax', 24, 'Max temperature', 'C', () => {}),
            _CardParameter(
                13, 'TMaxR', 24, 'Max temperature recovery ', 'C', () => {}),
            _CardParameter(13, 'TMin', 24, 'Min temperature', 'C', () => {}),
            _CardParameter(
                13, 'TMinR', 24, 'Min temperature recovery', 'C', () => {}),
          ],
        ),
      ));
}
