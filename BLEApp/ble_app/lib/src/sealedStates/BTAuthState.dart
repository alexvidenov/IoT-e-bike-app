import 'package:super_enum/super_enum.dart';

part 'BTAuthState.super.dart';

enum BTNotAuthenticatedReason { WrongPassword, DeviceDoesNotExist }

@superEnum
enum _BTAuthState {
  @object
  BTAuthenticated,

  @Data(fields: [DataField<BTNotAuthenticatedReason>('reason')])
  BTNotAuthenticated
}
