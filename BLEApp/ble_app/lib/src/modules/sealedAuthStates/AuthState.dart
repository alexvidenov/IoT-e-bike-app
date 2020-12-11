import 'package:sealed_class/sealed_class.dart';

part 'AuthState.g.dart';

@Sealed([Authenticated, NotAuthenticated, NoNetwork])
abstract class AuthState {}

class Authenticated implements AuthState {
  final String uid;

  const Authenticated(this.uid);
}

enum NotAuthenticatedError { EmailDoesNotExist, WrongPassword }

class NotAuthenticated implements AuthState {
  final NotAuthenticatedError reason;

  const NotAuthenticated(this.reason);
}

class NoNetwork implements AuthState {}