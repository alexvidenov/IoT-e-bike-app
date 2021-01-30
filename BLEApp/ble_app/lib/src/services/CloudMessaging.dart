import 'package:ble_app/src/persistence/LocalDatabaseManager.dart';
import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) async {
  print('ON BACKGROUND CALLED');
  final LocalDatabase localDatabase = await LocalDatabase.getInstance();
  final LocalDatabaseManager _dbManager = LocalDatabaseManager(localDatabase);
  /*
  if (message.containsKey('data')) {
    final Map<String, String> parameters = message['data'];
    parameters.entries.forEach((element) {
      switch(element.key){
        case '01':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(maxCellVoltage: double.parse(value));
          break;
        case '02':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(maxRecoveryVoltage: double.parse(value));
          break;
        case '03':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(balanceCellVoltage: double.parse(value));
          break;
        case '04':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(minCellVoltage: double.parse(value));
          break;
        case '05':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(minCellRecoveryVoltage: double.parse(value));
          break;
        case '06':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(ultraLowCellVoltage: double.parse(value));
          break;
        case '12':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(maxTimeLimitedDischargeCurrent: double.parse(value));
          break;
        case '13':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(maxCutoffDischargeCurrent: double.parse(value));
          break;
        case '14':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(maxCurrentTimeLimitPeriod: int.parse(value));
          break;
        case '15':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(maxCutoffChargeCurrent: double.parse(value));
          break;
        case '16':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(motoHoursCounterCurrentThreshold: int.parse(value));
          break;
        case '17':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(currentCutOffTimerPeriod: int.parse(value));
          break;
        case '23':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(maxCutoffTemperature: int.parse(value));
          break;
        case '24':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(maxTemperatureRecovery: int.parse(value));
          break;
        case '25':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(minTemperatureRecovery: int.parse(value));
          break;
        case '26':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(minCutoffTemperature: int.parse(value));
          break;
        case '28':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(motoHoursChargeCounter: int.parse(value));
          break;
        case '29':
          newModel = _parameterHolder.deviceParameters.value
              .copyWith(motoHoursDischargeCounter: int.parse(value));
          break;
      }
   */
  //})
  final String data =
      message['data']['01'].toString(); // later on do stuff with that
}

@lazySingleton
class CloudMessaging {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  init() => _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onBackgroundMessage: backgroundMessageHandler);

  // TODO: request permissions

  Future<String> getToken() async => await _fcm.getToken();
}
