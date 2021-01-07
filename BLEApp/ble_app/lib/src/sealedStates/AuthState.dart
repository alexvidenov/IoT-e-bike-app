import 'package:flutter/material.dart';
import 'package:super_enum/super_enum.dart';

part 'AuthState.super.dart';

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

@superEnum
enum _AuthState {
  @Data(fields: [DataField<String>('userId')])
  Authenticated,

  @Data(fields: [DataField<NotAuthenticatedReason>('reason')])
  NotAuthenticated
}
