import 'package:ble_app/src/modules/dataClasses/deviceParametersModel.dart';
import 'package:super_enum/super_enum.dart';

part 'ParameterFetchState.super.dart';

@superEnum
enum _ParameterFetchState {
  @Data(fields: [DataField<DeviceParametersModel>('parameters')])
  Fetched,

  @object
  Fetching
}
