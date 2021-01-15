import 'package:ble_app/src/events/blocEvent.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'BTAuthEvents.freezed.dart';

@freezed
abstract class BTAuthEvent with _$BTAuthEvent {
  const factory BTAuthEvent.authenticate([String pinCode]) = BTAuthenticate;
}

