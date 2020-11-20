import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'abstractVisibleWidget.dart';

class DeviceScreen extends VisibleWidget {
  final bloc = GetIt.I<ShortStatusBloc>();

  DeviceScreen({@required Key key}) : super(key: key);

  @override
  Widget buildWidget() {
    return Container(
      child: ProgressRows(),
    );
  }

  @override
  void onPause() {
    bloc.cancel();
  }

  @override
  void onResume() {
    bloc.resume();
  }

  @override
  void onCreate() {
    bloc.startGeneratingShortStatus();
  }

  @override
  void onDestroy() {
    bloc.dispose();
  }
}
