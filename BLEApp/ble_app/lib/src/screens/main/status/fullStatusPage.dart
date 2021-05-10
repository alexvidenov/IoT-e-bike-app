import 'package:ble_app/src/blocs/fullStatusBloc.dart';
import 'package:ble_app/src/screens/base/BlocLifecycleAware.dart';
import 'package:ble_app/src/widgets/FullStatusUI/VoltagesBarChart.dart';
import 'package:flutter/material.dart';

class FullStatusScreen
    extends BlocLifecycleAwareKeepAliveWidget<FullStatusBloc> {
  const FullStatusScreen(FullStatusBloc fullStatusBloc)
      : super(bloc: fullStatusBloc);

  @override
  void onCreate() {
    super.onCreate();
    bloc.initMotoTimers();
  }

  @override
  Widget buildWidget(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Battery status'),
          backgroundColor: Colors.black,
          centerTitle: false,
        ),
        body: VoltagesBarChart(bloc),
      );

  @override
  void onDestroy() {
    super.onDestroy();
    print('DESTROYING FULL STATUS');
  }
}
