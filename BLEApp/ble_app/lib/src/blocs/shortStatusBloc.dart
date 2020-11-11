import 'dart:async';

import 'package:ble_app/src/modules/shortStatusModel.dart';
import 'package:ble_app/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:ble_app/src/blocs/BluetoothRepository.dart';
import 'package:ble_app/src/blocs/Bloc.dart';
import 'package:rxdart/rxdart.dart';

class ShortStatusBloc extends Bloc {
  final BluetoothRepository repository;

  //final _shortStatus$ = StreamController<ShortStatusModel>();

  final _shortStatus$ = BehaviorSubject<ShortStatusModel>();

  Stream<ShortStatusModel> get shortStatus => _shortStatus$.stream;

  ShortStatusBloc({@required this.repository}) {
    repository.characteristicValueStream.listen((event) {
      var model = Converter.generateShortStatus(event);
      _shortStatus$.sink.add(model);
    });
  }

  @override
  void dispose() {
    _shortStatus$.close();
  }
}
