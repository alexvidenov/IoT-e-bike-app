import 'package:sealed_class/sealed_class.dart';

part 'BTAuthState.g.dart';

@Sealed([BTAuthenticated, BTNotAuthenticated])
abstract class BTAuthState {}

class BTAuthenticated implements BTAuthState {}

enum NotBTAuthenticatedError { WrongPassword, DeviceIsNotRegistered }

class BTNotAuthenticated implements BTAuthState {
  final notBTAuthenticatedError;

  const BTNotAuthenticated(this.notBTAuthenticatedError);
}
