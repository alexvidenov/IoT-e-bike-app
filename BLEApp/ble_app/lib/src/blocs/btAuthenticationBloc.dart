import 'package:ble_app/src/persistence/LocalDatabaseManager.dart';
import 'package:ble_app/src/blocs/bloc.dart';
import 'package:ble_app/main.dart';
import 'package:ble_app/src/persistence/entities/deviceState.dart';
import 'package:ble_app/src/persistence/entities/device.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:ble_app/src/sealedStates/btAuthState.dart';
import 'package:ble_app/src/utils/bluetoothUtils.dart';
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
          // see how that even works
          serialNumSecondPart =
              '${event[3]}' + '${event[4]}' + '${event[5]}' + '${event[6]}';
          String serialNumber =
              _extractSerialNumber(); // this serial number will be used as params id
          print('GOTTEN SERIAL NUMBER => $serialNumber');
          // Guard from empty serial number (only admin case..)
          if (await _db.isAnonymous() &&
              !await _db.deviceExists(serialNumber)) {
            // this will fail since when hardware is fresh, there won't be any serial number returned and inserted device will have empty id
            _db.insertDevice(Device(
              serialNumber,
              BluetoothUtils.defaultBluetoothDeviceName,
              false,
            ));
            _db.insertDeviceState(
                DeviceState(deviceNumber: serialNumber, isBatteryOn: false));
            _db.insertUserWithDevice('0000',
                serialNumber); // extract shit from the Auth 0000 flying string into constants
          }
          _repository.deviceSerialNumber =
              serialNumber; // REAL serial number here. (this line is duplicated btw. we set serial number in the devicesBloc as well to support offline mode )
          addEvent(BTAuthState
              .btAuthenticated()); // or not authenticated if fetched serial number is not equal. If anonymous, authenticated by default
        }
      });

  String _extractSerialNumber() => serialNumFirstPart + serialNumSecondPart;

  void setMacAddress(String mac) {
    _repository.deviceMacAddress = mac;
    _db.setMacAddress(mac);
  }

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
