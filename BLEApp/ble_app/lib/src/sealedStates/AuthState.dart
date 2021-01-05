import 'package:super_enum/super_enum.dart';

part 'AuthState.super.dart';

@superEnum
enum _AuthState {
  @Data(fields: [DataField<String>('userId')])
  Authenticated,

  @object
  NotAuthenticated
}
