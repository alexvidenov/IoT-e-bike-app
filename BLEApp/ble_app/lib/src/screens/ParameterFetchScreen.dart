import 'package:ble_app/src/blocs/PageManager.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/parameterFetchBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/screens/routeAware.dart';
import 'package:ble_app/src/sealedStates/parameterFetchState.dart';
import 'package:ble_app/src/utils/StreamListener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';

class ParameterFetchScreen extends MapRouteAwareWidget<ParameterFetchBloc> {
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
  Widget buildWidget(BuildContext context) {
    final dialog = YYProgressDialogBody(context);
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => super.bloc.queryParameters())
          ],
        ),
        body: WillPopScope(
          onWillPop: () => _onWillPop(context),
          child: StreamListener<ParameterFetchState>(
            stream: super.bloc.stream,
            onData: (state) {
              state.when(
                  fetched: (_) {
                    dialog.dismiss();
                    WidgetsBinding.instance.addPostFrameCallback(
                        (_) => $<PageManager>().openHome());
                  },
                  fetching: () => dialog.show());
            },
            child: Container(),
          ),
        ));
  }

  YYDialog YYProgressDialogBody(context) => YYDialog().build(context)
    ..width = 400
    ..borderRadius = 4.0
    ..circularProgress(
      padding: EdgeInsets.all(24.0),
      valueColor: Colors.orange[500],
    )
    ..text(
      padding: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 12.0),
      text: "Fetching...",
      alignment: Alignment.center,
      color: Colors.blue[500],
      fontSize: 22.0,
    );
}
