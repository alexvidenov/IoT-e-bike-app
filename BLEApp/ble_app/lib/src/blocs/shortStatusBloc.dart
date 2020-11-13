import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:ble_app/src/blocs/StreamOwner.dart';
import 'package:ble_app/src/modules/shortStatusModel.dart';
import 'package:ble_app/src/blocs/BluetoothRepository.dart';
import 'package:ble_app/src/utils.dart';
import 'package:flutter/material.dart';

class ShortStatusBloc extends StreamOwner {
  final BluetoothRepository repository;

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
    repository.dispose();
  }
}
