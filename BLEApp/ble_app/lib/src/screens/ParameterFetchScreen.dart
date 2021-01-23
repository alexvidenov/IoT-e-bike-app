import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/parameterFetchBloc.dart';
import 'package:ble_app/src/persistence/localDatabase.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/sealedStates/parameterFetchState.dart';
import 'package:flutter/material.dart';

class ParameterFetchScreen extends RouteAwareWidget<ParameterFetchBloc> {
  const ParameterFetchScreen(
      ParameterFetchBloc _deviceParameterBloc, this._deviceBloc)
      : super(bloc: _deviceParameterBloc);

  final DeviceBloc _deviceBloc; // remove this in release, not needed

  Future<bool> _onWillPop(context) => showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Are you sure?',
                style: TextStyle(fontFamily: 'Europe_Ext')),
            content: Text(
                'Do you want to disconnect from the device and go back?',
                style: TextStyle(fontFamily: 'Europe_Ext')),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No')),
              FlatButton(
                  onPressed: () {
                    _deviceBloc.disconnect();
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes')),
            ],
          ) ??
          false);

  @override
  Widget buildWidget(BuildContext context) => Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => super.bloc.queryParameters())
        ],
      ),
      body: WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: StreamBuilder<ParameterFetchState>(
          stream: super.bloc.stream,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              snapshot.data.when(
                  fetched: (fetched) {
                    super.bloc.setParameters(fetched);
                    WidgetsBinding.instance.addPostFrameCallback((_) =>
                        Navigator.of(context).pushReplacementNamed('/home'));
                  },
                  fetching: () => Center(child: CircularProgressIndicator()));
            } else
              return Container();
            return Container();
          },
        ),
      ));
}
