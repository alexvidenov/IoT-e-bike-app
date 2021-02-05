import 'dart:typed_data';

import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusModel.dart';
import 'package:ble_app/src/services/Storage.dart';
import 'package:injectable/injectable.dart';

import 'bloc.dart';

@injectable
class DeviceStatisticsBloc with CurrentContext {
  Storage get _storage => Storage(uid: curUserId);

  Future<String> fetchData() async => await _storage.download();
}
