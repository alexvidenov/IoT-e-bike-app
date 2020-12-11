// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthState.dart';

// **************************************************************************
// SealedGenerator
// **************************************************************************

extension AuthStateExt on AuthState {
  void continued(
    Function(Authenticated) continuationAuthenticated,
    Function(NotAuthenticated) continuationNotAuthenticated,
    Function(NoNetwork) continuationNoNetwork,
  ) {
    if (this is Authenticated) {
      continuationAuthenticated(this);
    }
    if (this is NotAuthenticated) {
      continuationNotAuthenticated(this);
    }
    if (this is NoNetwork) {
      continuationNoNetwork(this);
    }
  }

  R join<R>(
    R Function(Authenticated) joinAuthenticated,
    R Function(NotAuthenticated) joinNotAuthenticated,
    R Function(NoNetwork) joinNoNetwork,
  ) {
    R r;
    if (this is Authenticated) {
      r = joinAuthenticated(this);
    }
    if (this is NotAuthenticated) {
      r = joinNotAuthenticated(this);
    }
    if (this is NoNetwork) {
      r = joinNoNetwork(this);
    }

    return r;
  }
}
