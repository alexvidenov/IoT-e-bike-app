import 'package:freezed_annotation/freezed_annotation.dart';

import 'fullStatusBarGraphModel.dart';

part 'fullStatusModel.freezed.dart';

enum BattStatus { OK, OC, OD, OCOD, ERROR, SC }

extension BattStatusToString on BattStatus {
  String string() => this.toString().split('.').last;
}

@freezed
abstract class FullStatusModel with _$FullStatusModel {
  const factory FullStatusModel(
      List<FullStatusDataModel> fullStatus,
      double totalVoltage,
      double current,
      int temperature,
      int rIn,
      BattStatus status) = _FullStatus;
}
