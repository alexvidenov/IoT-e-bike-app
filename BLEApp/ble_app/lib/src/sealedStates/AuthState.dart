import 'package:flutter/material.dart';
import 'package:super_enum/super_enum.dart';

part 'AuthState.super.dart';

enum NotAuthenticatedReason { WrongPassword, EmailDoesNotExist }

@superEnum
enum _AuthState {
  @Data(fields: [DataField<String>('userId')])
  Authenticated,

  @Data(fields: [DataField<NotAuthenticatedReason>('reason')])
  NotAuthenticated
}
