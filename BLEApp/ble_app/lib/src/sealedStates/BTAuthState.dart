import 'package:freezed_annotation/freezed_annotation.dart';

part 'BTAuthState.freezed.dart';

enum BTNotAuthenticatedReason { WrongPassword, DeviceIsNotRegistered }

@freezed
abstract class BTAuthState with _$BTAuthState {
  const factory BTAuthState.btAuthenticated() = BTAuthenticated;

  const factory BTAuthState.notBTAuthenticated(
      [BTNotAuthenticatedReason reason]) = BTNotAuthenticated;

  const factory BTAuthState.authenticating() = Authenticating;
}
