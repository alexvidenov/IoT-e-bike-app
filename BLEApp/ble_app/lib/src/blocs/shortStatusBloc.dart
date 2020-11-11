import 'dart:async';
import 'package:ble_app/src/modules/shortStatusModel.dart';
import 'package:ble_app/src/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShortStatusBloc extends Bloc<String, ShortStatusModel> {
  @override
  get initialState => ShortStatusModel();

  @override
  Stream<ShortStatusModel> mapEventToState(event) async* {
    var shortStatus = Converter.generateShortStatus(event);
    yield shortStatus;
  }
}
