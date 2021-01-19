import 'package:freezed_annotation/freezed_annotation.dart';

part 'authState.freezed.dart';

enum NotAuthenticatedReason {
  emailAlreadyExists,
  wrongPassword,
  invalidEmail,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.authenticated(String userId) = _Authenticated;

  const factory AuthState.failedToAuthenticate(
      {NotAuthenticatedReason reason}) = _FailedToAuthenticate;
}
