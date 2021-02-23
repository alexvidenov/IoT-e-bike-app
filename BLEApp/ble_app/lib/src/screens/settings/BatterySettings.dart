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
import 'package:jiffy/jiffy.dart';

typedef EditedParameterCallback = Future<void> Function(String, String);

typedef CalibrateCallback = void Function();

class _CardParameter extends StatelessWidget {
  // Should keep the last value. If it doesn't program correctly, return the old value
  final int _showcaseIndex;
  final String _tableIndex;
  final String _parameterName;
  final num _parameterValue;
  final String _measureUnit;
  final String _description;
  final EditedParameterCallback _onEdit;

  const _CardParameter(
      this._showcaseIndex,
      this._tableIndex,
      this._parameterName,
      this._parameterValue,
      this._description,
      this._measureUnit,
      this._onEdit);

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
                              TextEditingValue(text: '$_parameterValue')),
                          onFieldSubmitted: (value) =>
                              _onEdit(_tableIndex, value),
                        ),
                      ),
                      Text(
                        '$_measureUnit',
                        style: TextStyle(fontSize: 20, color: Colors.black),
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
        super(
            bloc: parameterListenerBloc,
            key: PageStorageKey('BatterySettingsScreen'));

  Future<void> numCellsCompletion(String _, String value) async {
    _repository.cancel();
    final remainder = int.parse(value).remainder(4);
    _runAfter200ms(() async {
      if (remainder == 1) {
        _parameterListenerBloc.programNumOfCellsFirstNode(value,
            reminderValue: (remainder + 1).toString());
        await Future.delayed(Duration(milliseconds: 250),
            () => _parameterListenerBloc.programNumOfCellsSecondNode(value));
      } else if (remainder != 0) {
        _parameterListenerBloc.programNumOfCellsFirstNode(value,
            reminderValue: (remainder).toString());
        await Future.delayed(
            Duration(milliseconds: 250),
            () => _parameterListenerBloc.programNumOfCellsSecondNode(value,
                reminderValue: '4'));
      } else {
        _parameterListenerBloc.programNumOfCellsFirstNode(value,
            reminderValue: '4');
        await Future.delayed(
            Duration(milliseconds: 250),
            () => _parameterListenerBloc.programNumOfCellsSecondNode(value,
                reminderValue: '4'));
      }
    }).then((_) => Future.delayed(
        Duration(milliseconds: 100), () => _repository.resume()));
  }

  Future<void> completion(String key, String value) async {
    _repository.cancel();
    _runAfter200ms(() => _parameterListenerBloc.changeParameter(key, value))
        .then((_) => Future.delayed(
            Duration(milliseconds: 100), () => _repository.resume()));
  }

  Future<void> _runAfter200ms(Function() func) async =>
      await Future.delayed(Duration(milliseconds: 200), () => func());

  Future<void> serialNumberCompletion(String key, String value) async {
    // only for superusers
    final year = DateTime.now().year.toString();
    final currentDay = Jiffy().dayOfYear;
    _repository.cancel();
    await _write(key, '${year[3]}' + '$currentDay');
    await _write((int.parse(key) + 1).toString(), value);
    Future.delayed(Duration(milliseconds: 80), () => _repository.resume());
  }

  Future<void> _write(String key, String value) async => await Future.delayed(
      Duration(milliseconds: 100),
      () => _parameterListenerBloc.changeParameter(key, value));

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
  Widget buildWidget(BuildContext context) {
    return StreamListener(
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
                          0,
                          '00',
                          'Cell Num',
                          snapshot.data.cellCount ?? 4,
                          'Number of active cells',
                          '',
                          numCellsCompletion),
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
                          (snapshot.data.motoHoursCounterCurrentThreshold) ??
                              40,
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
                      _CardParameter(17, '44', 'Serial number', 0000, '', '',
                          serialNumberCompletion),
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
                                          topRight:
                                              const Radius.circular(25.0))),
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
                                      OutlineButton(
                                        child: Text(
                                          'Register device',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.lightGreen),
                                        ),
                                        onPressed: () => FirestoreDatabase(
                                                uid: this.bloc.curUserId,
                                                deviceId: this.bloc.curDeviceId)
                                            .uploadDevice(
                                                macAddress: $<DeviceBloc>()
                                                    .device
                                                    .value
                                                    .id,
                                                parameters: this
                                                    .bloc
                                                    .currentParams
                                                    .toMap()),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ))),
            )));
  }
}
