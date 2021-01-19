import 'package:ble_app/src/modules/dataClasses/deviceParametersModel.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'parameterFetchState.freezed.dart';

@freezed
abstract class ParameterFetchState with _$ParameterFetchState {
  const factory ParameterFetchState.fetched(DeviceParametersModel model) =
      _Fetched;

  const factory ParameterFetchState.fetching() = _Fetching;
}
