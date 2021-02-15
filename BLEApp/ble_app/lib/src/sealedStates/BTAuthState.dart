import 'package:freezed_annotation/freezed_annotation.dart';

part 'btAuthState.freezed.dart';

enum BTNotAuthenticatedReason { WrongPassword, DeviceIsNotRegistered }

@freezed
abstract class BTAuthState with _$BTAuthState {
  const factory BTAuthState.btAuthenticated() = _BTAuthenticated;

  const factory BTAuthState.failedToBTAuthenticate(
      {BTNotAuthenticatedReason reason}) = _BTNotAuthenticated;
}
