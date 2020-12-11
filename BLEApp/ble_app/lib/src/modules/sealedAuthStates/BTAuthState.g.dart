// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BTAuthState.dart';

// **************************************************************************
// SealedGenerator
// **************************************************************************

extension BTAuthStateExt on BTAuthState {
  void continued(
    Function(BTAuthenticated) continuationBTAuthenticated,
    Function(BTNotAuthenticated) continuationBTNotAuthenticated,
  ) {
    if (this is BTAuthenticated) {
      continuationBTAuthenticated(this);
    }
    if (this is BTNotAuthenticated) {
      continuationBTNotAuthenticated(this);
    }
  }

  R join<R>(
    R Function(BTAuthenticated) joinBTAuthenticated,
    R Function(BTNotAuthenticated) joinBTNotAuthenticated,
  ) {
    R r;
    if (this is BTAuthenticated) {
      r = joinBTAuthenticated(this);
    }
    if (this is BTNotAuthenticated) {
      r = joinBTNotAuthenticated(this);
    }

    return r;
  }
}
