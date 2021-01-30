import 'package:ble_app/src/persistence/LocalDatabaseManager.dart';
import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/sealedStates/btAuthState.dart';
import 'package:ble_app/src/services/Database.dart';
import 'package:injectable/injectable.dart';

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
          await _querySerialNumber();
          //List<String> objects = event.split(' ');
          //String deviceId = objects.elementAt(1);
          // later on change to what the actual parameter name will be
          //if (!await checkUserExistsWithDevice(_db.curDeviceId)) {
          //addEvent(BTAuthState.failedToBTAuthenticate(
          //reason: BTNotAuthenticatedReason.DeviceIsNotRegistered));
          // } else {
          if (await _db.isAnonymous()) {
            _repository.deviceSerialNumber = '1234';
          } else {
            _repository.deviceSerialNumber =
                1234567.toString(); // TODO: fetch 55 param here (for example)
          }
        } else if (event.startsWith('R44')) {
          serialNumFirstPart =
              '${event[3]}' + '${event[4]}' + '${event[5]}' + '${event[6]}';
        } else if (event.startsWith('R45')) {
          serialNumSecondPart =
              '${event[3]}' + '${event[4]}' + '${event[5]}' + '${event[6]}';
          String number = extractSerialNumber();
          addEvent(BTAuthState.btAuthenticated());
          print('GOTTEN SERIAL NUMBER => $number');
        }
      });

  setMacAddressIfNull(String mac) {
    _repository.deviceMacAddress = mac; // this may be unnecessary
    FirestoreDatabase(uid: _db.curUserId, deviceId: _db.curDeviceId)
        .setDeviceMacAddress(mac: mac);
    _db.setMacAddress(_repository.deviceMacAddress);
  }

  String extractSerialNumber() => serialNumFirstPart + serialNumSecondPart;

  Future<void> _querySerialNumber() async {
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
