import 'package:ble_app/src/modules/dataClasses/BaseModel.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ble_app/src/modules/dataClasses/BaseStatus.dart';

import 'BatteryState.dart';

part 'statusState.freezed.dart';

@freezed
abstract class StatusState<T extends BaseModel> with _$StatusState<T> {
  @With.fromString('BaseStatus<T>')
  const factory StatusState(BatteryState state, [T model]) = Status<T>;
}
