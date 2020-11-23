import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/devicesBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/devicesListScreen.dart';
import 'package:ble_app/src/screens/home.dart';
import 'package:ble_app/src/widgets/navigationDrawer.dart';
import 'package:flutter/material.dart';

abstract class AppBarWidget extends StatefulWidget {
  Widget buildWidget(BuildContext context);

  void onCreate();

  void onPause();

  void onResume();

  void onDestroy();

  const AppBarWidget({Key key}) : super(key: key);

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> with RouteAware {
  final _prefsBloc = locator<SettingsBloc>();

  final _deviceBloc = locator<DeviceBloc>();

  @override
  void initState() {
    super.initState();
    widget.onCreate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    super.didPush();
    widget.onResume();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    widget.onResume();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.white12,
          title: Text("Home"),
          actions: <Widget>[
            RaisedButton(
                color: Colors.lightBlueAccent,
                child:
                    Text('BT Devices', style: TextStyle(color: Colors.white)),
                onPressed: () => _prefsBloc
                    .clearAllPrefs()
                    .then((_) => _deviceBloc.disconnect())
                    .then((value) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DevicesListScreen(locator<DevicesBloc>()),
                        )))),
          ],
        ),
        drawer: NavigationDrawer(),
        body: this.widget.buildWidget(context));
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
    widget.onDestroy();
  }
}
