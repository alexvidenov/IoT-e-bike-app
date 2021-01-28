import 'dart:typed_data';

import 'package:ble_app/src/blocs/CurrentContext.dart';
import 'package:ble_app/src/modules/dataClasses/fullStatusModel.dart';
import 'package:ble_app/src/services/Storage.dart';

import 'bloc.dart';

class DeviceStatisticsBloc extends Bloc<FullStatusModel, String>
    with CurrentContext {
  get _storage => Storage(uid: this.curUserId);

  Future<Uint8List> loadData() {}
}
