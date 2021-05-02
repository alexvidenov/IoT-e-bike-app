import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/parameterListenerBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:ble_app/src/utils/StreamListener.dart';
import 'package:flutter/material.dart';

typedef EditedParameterCallback = Future<void> Function(String, String);

typedef CalibrateCallback = void Function();

class _CardParameter extends StatelessWidget {
  // Should keep the last value. If it doesn't program correctly, return the old value
  final int _showcaseIndex;
  final String _tableIndex;
  final String _parameterName;
  final num parameterValue;
  final String parameterValueAsString;
  final String _measureUnit;
  final String _description;
  final EditedParameterCallback _onEdit;

  const _CardParameter(this._showcaseIndex, this._tableIndex,
      this._parameterName, this._description, this._measureUnit, this._onEdit,
      {this.parameterValue, this.parameterValueAsString});

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
                          style: TextStyle(fontSize: 25, color: Colors.black),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: TextEditingController.fromValue(
                              TextEditingValue(
                                  text: parameterValue != null
                                      ? '$parameterValue'
                                      : parameterValueAsString)),
                          onFieldSubmitted: (value) =>
                              _onEdit(_tableIndex, value),
                          style: TextStyle(fontSize: 24, color: Colors.black),
                        ),
                      ),
                      Text(
                        '$_measureUnit',
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      ),
                    ]),
                subtitle: Text(_description),
                trailing: const Icon(Icons.keyboard_arrow_right)),
          ],
        ),
      );
}

class CalibrateTile extends StatelessWidget {
  final int _showcaseIndex;
  final String _parameterName;
  final String _description;
  final CalibrateCallback _calibrateCallback;

  const CalibrateTile(this._showcaseIndex, this._parameterName,
      this._description, this._calibrateCallback);

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
                        child: Text(
                          '$_parameterName :',
                          style: TextStyle(fontSize: 24, color: Colors.black),
                        ),
                      ),
                    ]),
                subtitle: Text(_description),
                trailing: const Icon(Icons.edit_sharp),
                onTap: () => _calibrateCallback(),
                tileColor: Colors.lightBlueAccent),
          ],
        ),
      );
}

class BatterySettingsScreen extends RouteAwareWidget<ParameterListenerBloc> {
  final ParameterListenerBloc _parameterListenerBloc;
  final DeviceRepository _repository;

  final scaffoldState = GlobalKey<ScaffoldState>();

  BatterySettingsScreen(
      ParameterListenerBloc parameterListenerBloc, this._repository)
      : this._parameterListenerBloc = parameterListenerBloc,
        super(bloc: parameterListenerBloc);

  Future<void> completion(String key, String value) async {
    _repository.cancel();
    _runAfter200ms(() => _parameterListenerBloc.changeParameter(key, value))
        .then((_) => Future.delayed(
            Duration(milliseconds: 100), () => _repository.resume()));
  }

  Future<void> _runAfter200ms(Function() func) async =>
      await Future.delayed(Duration(milliseconds: 200), () => func());

  Future<void> _showDialog(context, bool success) async {
    success
        ? AwesomeDialog(
            context: context,
            useRootNavigator: true,
            dialogType: DialogType.SUCCES,
            headerAnimationLoop: false,
            animType: AnimType.TOPSLIDE,
            title: 'Successful',
            desc: 'Parameter changed',
            autoHide: Duration(seconds: 2),
          ).show()
        : AwesomeDialog(
            context: context,
            useRootNavigator: true,
            dialogType: DialogType.ERROR,
            animType: AnimType.SCALE,
            title: 'Failed',
            desc: 'Parameter change failed. Retry?',
            btnOkText: 'Yes',
            btnOkOnPress: () => _parameterListenerBloc.retry(),
            btnCancelText: 'Cancel',
            btnCancelOnPress: () => this.buildWidget(context)).show();
  }

  @override
  Widget buildWidget(BuildContext context) => StreamListener(
      stream: _parameterListenerBloc.stream,
      onData: (status) {
        switch (status) {
          case ParameterChangeStatus.Successful:
            _showDialog(context, true);
            break;
          case ParameterChangeStatus.Unsuccessful:
            _showDialog(context, false);
            break;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            title: const Text('Battery Settings'),
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
              child: StreamBuilder<DeviceParameters>(
            stream: _parameterListenerBloc.parameters,
            initialData: bloc.currentParams,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _CardParameter(
                      17,
                      '44',
                      'Serial number',
                      '',
                      '',
                      (_, __) async => {},
                      parameterValueAsString: _repository.deviceSerialNumber,
                    ),
                    _CardParameter(
                      0,
                      '00',
                      'Cell Num',
                      'Number of active cells',
                      '',
                      (_, __) async => {},
                      parameterValue: snapshot.data.cellCount ?? 4,
                    ),
                    _CardParameter(
                      1,
                      '01',
                      'V Max',
                      'Max cell voltage',
                      'V',
                      completion,
                      parameterValue: (snapshot.data.maxCellVoltage) ?? 4.28,
                    ),
                    _CardParameter(
                      2,
                      '02',
                      'V MaxR',
                      'Max recovery voltage',
                      'V',
                      completion,
                      parameterValue:
                          (snapshot.data.maxRecoveryVoltage) ?? 4.15,
                    ),
                    _CardParameter(
                      3,
                      '03',
                      'V Bal',
                      'Balance cell voltage',
                      'V',
                      completion,
                      parameterValue:
                          (snapshot.data.balanceCellVoltage) ?? 4.20,
                    ),
                    _CardParameter(
                      4,
                      '04',
                      'VMin',
                      'Min cell voltage',
                      'V',
                      completion,
                      parameterValue: (snapshot.data.minCellVoltage) ?? 2.80,
                    ),
                    _CardParameter(
                      5,
                      '05',
                      'VMinR',
                      'Min cell recovery voltage',
                      'V',
                      completion,
                      parameterValue:
                          (snapshot.data.minCellRecoveryVoltage) ?? 3.10,
                    ),
                    _CardParameter(
                      6,
                      '06',
                      'VULOW',
                      'Ultra low cell voltage',
                      'V',
                      completion,
                      parameterValue: (snapshot.data.ultraLowCellVoltage) ?? 2,
                    ),
                    _CardParameter(
                      7,
                      '12',
                      'IDMax1',
                      'Max limited discharge current',
                      'A',
                      completion,
                      parameterValue:
                          (snapshot.data.maxTimeLimitedDischargeCurrent) ?? 20,
                    ),
                    _CardParameter(
                      8,
                      '13',
                      'IDMax2',
                      'Max cut-off discharge current',
                      'A',
                      completion,
                      parameterValue:
                          (snapshot.data.maxCutoffDischargeCurrent) ?? 25,
                    ),
                    _CardParameter(
                      9,
                      '14',
                      'Id max 1 time',
                      'Max current time-limit period',
                      's',
                      completion,
                      parameterValue:
                          snapshot.data.maxCurrentTimeLimitPeriod ?? 10,
                    ),
                    _CardParameter(
                      10,
                      '15',
                      'ICMax',
                      'Max cut-off charge current',
                      'A',
                      completion,
                      parameterValue:
                          (snapshot.data.maxCutoffChargeCurrent) ?? 8,
                    ),
                    _CardParameter(
                      11,
                      '16',
                      'I Thr Count',
                      'Moto-hours current threshold',
                      'A',
                      completion,
                      parameterValue:
                          (snapshot.data.motoHoursCounterCurrentThreshold) ??
                              40,
                    ),
                    _CardParameter(
                      12,
                      '17',
                      'I Max c-off Time ',
                      'Max cut-off time period',
                      's',
                      completion,
                      parameterValue:
                          snapshot.data.currentCutOffTimerPeriod ?? 5,
                    ),
                    _CardParameter(
                      13,
                      '23',
                      'T Max',
                      'Max temperature cut-off',
                      '°C',
                      completion,
                      parameterValue:
                          (snapshot.data.maxCutoffTemperature) ?? 240,
                    ),
                    _CardParameter(
                      14,
                      '24',
                      'T MaxR',
                      'Max temperature recovery ',
                      '°C',
                      completion,
                      parameterValue:
                          snapshot.data.maxTemperatureRecovery ?? 530,
                    ),
                    _CardParameter(
                      15,
                      '25',
                      'T MinR',
                      'Min temperature recovery',
                      '°C',
                      completion,
                      parameterValue:
                          snapshot.data.minTemperatureRecovery ?? 1680,
                    ),
                    _CardParameter(
                      16,
                      '26',
                      'T Min',
                      'Min temperature cut-off',
                      '°C',
                      completion,
                      parameterValue:
                          snapshot.data.minCutoffTemperature ?? 2480,
                    ),
                  ],
                );
              } else
                return Container();
            },
          )),
          floatingActionButton: Builder(
            builder: (context) => FloatingActionButton(
                elevation: 7,
                child: Icon(Icons.build),
                onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (_) => Wrap(
                          children: [
                            Container(
                              child: Container(
                                decoration: new BoxDecoration(
                                    color: Color(0xFF737373),
                                    borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(25.0),
                                        topRight: const Radius.circular(25.0))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CalibrateTile(
                                        18,
                                        'Cal. V',
                                        'Voltage calibrate',
                                        () => _parameterListenerBloc
                                            .calibrateVoltage()),
                                    CalibrateTile(
                                        19,
                                        'Cal. C',
                                        'Charge calibrate',
                                        () => _parameterListenerBloc
                                            .calibrateCharge()),
                                    CalibrateTile(
                                        20,
                                        'Cal. D',
                                        'Discharge calibrate',
                                        () => _parameterListenerBloc
                                            .calibrateDischarge()),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ))),
          )));
}
