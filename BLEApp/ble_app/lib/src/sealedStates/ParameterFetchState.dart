import 'package:ble_app/src/persistence/entities/deviceParameters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'parameterFetchState.freezed.dart';

@freezed
abstract class ParameterFetchState with _$ParameterFetchState {
  const factory ParameterFetchState.fetched(DeviceParameters model) = _Fetched;

  const factory ParameterFetchState.fetching() = _Fetching;
}
