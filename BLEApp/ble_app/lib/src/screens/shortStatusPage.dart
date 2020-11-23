import 'package:ble_app/src/blocs/shortStatusBloc.dart';
import 'package:ble_app/src/screens/home.dart';
import 'package:ble_app/src/widgets.dart';
import 'package:flutter/material.dart';

class DeviceScreen extends StatefulWidget {
  final ShortStatusBloc _shortStatusBloc;

  const DeviceScreen(this._shortStatusBloc);

  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> with RouteAware {
  @override
  void initState() {
    super.initState();
    widget._shortStatusBloc.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    super.didPush();
    widget._shortStatusBloc.resume();
  }

  @override
  void didPushNext() {
    super.didPushNext();
    widget._shortStatusBloc.pause();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    widget._shortStatusBloc.resume();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/full'),
      child: Container(
        child: ProgressRows(shortStatusBloc: widget._shortStatusBloc),
      ),
    ); //);
  }

  @override
  void dispose() {
    super.dispose();
    widget._shortStatusBloc.dispose();
  }
}
