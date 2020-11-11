import 'dart:async';
import 'package:ble_app/src/modules/shortStatusViewModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShortStatusEvent {
  ShortStatusViewModel shortStatusViewModel;

  ShortStatusEvent({this.shortStatusViewModel});

  ShortStatusViewModel getShortStatus() => shortStatusViewModel;
}

class ShortStatusBloc extends Bloc<ShortStatusEvent, ShortStatusViewModel> {
  @override
  get initialState => ShortStatusViewModel();

  @override
  Stream<ShortStatusViewModel> mapEventToState(event) async* {
    // the logic handling the event will be here. Event will be String
    yield event.getShortStatus();
  }
}
