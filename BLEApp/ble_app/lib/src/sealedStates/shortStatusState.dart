import 'package:ble_app/src/modules/dataClasses/shortStatusModel.dart';
import 'package:super_enum/super_enum.dart';

@superEnum
enum _ShortStatusState {
  @Data(fields: [DataField<ShortStatusModel>('shortStatus')])
  Overdischarge,

  @Data(fields: [DataField<ShortStatusModel>('shortStatus')])
  Overcharge
}
