import 'package:freezed_annotation/freezed_annotation.dart';

import 'BaseModel.dart';
import 'fullStatusBarGraphModel.dart';

part 'fullStatusModel.freezed.dart';

@freezed
abstract class FullStatusModel with _$FullStatusModel {
  @Implements(BaseModel)
  const factory FullStatusModel(
      {@Default([]) List<FullStatusDataModel> fullStatus,
      @Default(0) double totalVoltage,
      @Default(0) double current,
      @Default(0) int temperature,
      @Default(0) int rIn}) = FullStatus;
}
