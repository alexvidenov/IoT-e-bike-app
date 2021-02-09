import 'package:ble_app/src/blocs/DeviceStatisticsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/modules/jsonClasses/logFileModel.dart';
import 'package:ble_app/src/repositories/DeviceRepository.dart';
import 'package:flutter/material.dart';

class DeviceStatisticsScreen extends StatefulWidget {
  final DeviceStatisticsBloc _deviceStatisticsBloc;

  const DeviceStatisticsScreen(this._deviceStatisticsBloc);

  @override
  _DeviceStatisticsScreenState createState() => _DeviceStatisticsScreenState();
}

class _DeviceStatisticsScreenState extends State<DeviceStatisticsScreen> {
  @override
  void initState() {
    super.initState();
    $<DeviceRepository>().cancel();
    print('Fetching');
    fetch();
  }

  fetch() async {
    final data = await widget._deviceStatisticsBloc.fetchData();
    print('Data:' + data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class StatisticsData {
  final DateTime x;
  final double y;

  StatisticsData(this.x, this.y);

  factory StatisticsData.fromLogModel(LogModel model) =>
      StatisticsData(DateTime.parse(model.timeStamp), model.voltage);
}
