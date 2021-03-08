import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/persistence/LocalDatabaseManager.dart';
import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/sealedStates/btAuthState.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:injectable/injectable.dart';

import 'PageManager.dart';

part 'blocExtensions/BTAuthMethods.dart';

@injectable
class BluetoothAuthBloc extends Bloc<BTAuthState, String> {
  final DeviceRepository _repository;
  final LocalDatabaseManager _db;

  BluetoothAuthBloc(this._repository, this._db) : super();

  String serialNumFirstPart;
  String serialNumSecondPart;

  @override
  create() => streamSubscription =
          _repository.characteristicValueStream.listen((event) async {
        print(event);
        if (event.startsWith('OK')) {
          print('IF EVENTS STARTS WITH OK');
          await _querySerialNumber();
          //List<String> objects = event.split(' ');
          //String deviceId = objects.elementAt(1);
          // later on change to what the actual parameter name will be
          //if (!await checkUserExistsWithDevice(_db.curDeviceId)) {
          //addEvent(BTAuthState.failedToBTAuthenticate(
          //reason: BTNotAuthenticatedReason.DeviceIsNotRegistered));
          // } else {
        } else if (event.startsWith('R44')) {
          serialNumFirstPart =
              '${event[3]}' + '${event[4]}' + '${event[5]}' + '${event[6]}';
        } else if (event.startsWith('R45')) {
          serialNumSecondPart =
              '${event[3]}' + '${event[4]}' + '${event[5]}' + '${event[6]}';
          String number = extractSerialNumber();
          print('GOTTEN SERIAL NUMBER => $number');
          if (await _db.isAnonymous()) {
            _repository.deviceSerialNumber = '1234'; // serial number here
          } else {
            _repository.deviceSerialNumber =
                1234567.toString(); // TODO: fetch 55 param here (for example)
          }
          addEvent(BTAuthState
              .btAuthenticated()); // or not authenticated if fetched serial number is not equal. If anonymous, authenticated by default
        }
      });

  String extractSerialNumber() => serialNumFirstPart + serialNumSecondPart;

  Future<void> _querySerialNumber() async {
    print('QUERYING SERIAL NUMBER');
    _repository.cancel();
    await Future.delayed(Duration(milliseconds: 100), () async {
      _repository.writeToCharacteristic('R44\r');
      await Future.delayed(Duration(milliseconds: 100),
          () => _repository.writeToCharacteristic('R45\r'));
    });
  }

  @override
  dispose() {
    logger.wtf('Closing stream in BTAuthenticationBloc');
    super.dispose();
  }
}
