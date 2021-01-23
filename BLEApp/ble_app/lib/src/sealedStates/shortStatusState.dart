import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shortStatusState.freezed.dart';

enum ShortStatusErrorState {
  HighVoltage,
  Overcharge,
  OverDischarge,
  HighTemp,
  LowTemp,
}

// TODO: Generify
@freezed
abstract class ShortStatusState with _$ShortStatusState {
  const factory ShortStatusState(ShortStatusModel model) = Normal;

  const factory ShortStatusState.error(ShortStatusErrorState errorState,
      [ShortStatusModel model]) = ShortStatusError;
}
