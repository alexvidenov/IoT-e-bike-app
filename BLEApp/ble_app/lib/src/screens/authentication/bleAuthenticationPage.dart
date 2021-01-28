import 'dart:async';

import 'package:ble_app/src/persistence/LocalDatabaseManager.dart';
import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';

import 'package:ble_app/src/sealedStates/btAuthState.dart';
import 'package:ble_app/src/sealedStates/deviceConnectionState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';

class BLEAuthenticationScreen extends StatefulWidget {
  final DeviceBloc _deviceBloc;
  final BluetoothAuthBloc _authBloc;
  final SettingsBloc _settingsBloc;
  final LocalDatabaseManager _dbManager;

  const BLEAuthenticationScreen(
      this._deviceBloc, this._authBloc, this._settingsBloc, this._dbManager);

  @override
  _BLEAuthenticationScreenState createState() =>
      _BLEAuthenticationScreenState();
}

class _BLEAuthenticationScreenState extends State<BLEAuthenticationScreen> {
  final _writeController = TextEditingController();

  StreamSubscription<BTAuthState> _streamSubscriptionAuth;

  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  bool _isAuthenticated = false;

  bool _connected = false;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    widget._deviceBloc.stopScan();
    widget._authBloc.create();
    widget._deviceBloc.connect().then((_) => _init());
    _handleBLEError();
  }

  _init() {
    _listenToAuthBloc();
  }

  _handleBLEError() => Future.delayed(Duration(seconds: 6), () {
        //TODO:extract in some handlers object
        if (!_connected) widget._deviceBloc.connect();
      });

  @override
  dispose() {
    super.dispose();
    widget._deviceBloc.dispose();
    _streamSubscriptionAuth.cancel();
  }

  _listenToAuthBloc() =>
      _streamSubscriptionAuth = widget._authBloc.stream.listen((event) {
        event.when(
            btAuthenticated: () {
              this._verificationNotifier.add(true); // TODO: bro..
              widget._dbManager.setMacAddress(
                  widget._deviceBloc.device.value.id); // device Id is inferred
              _isAuthenticated = true;
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/fetchParameters', (_) => false);
            },
            failedToBTAuthenticate: (reason) => _presentDialog(context,
                message: reason.toString(), action: 'TRY AGAIN'));
      });

// this retry will be in the bloc
  _retry() => Future.delayed(Duration(seconds: 1), () {
        // CALL maybe pop here or somethingx
        if (_isAuthenticated == false)
          _showLockScreen(
            context,
            title: 'Wrong pin',
            opaque: true,
            cancelButton: Text(
              'Cancel',
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: 'Cancel',
            ),
          );
        //_presentDialog(context,
        //message: 'Wrong password', action: 'Try again');
      });

  _showLockScreen(BuildContext context,
      {String title,
      bool opaque,
      CircleUIConfig circleUIConfig,
      KeyboardUIConfig keyboardUIConfig,
      Widget cancelButton,
      List<String> digits}) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: opaque,
      pageBuilder: (context, animation, secondaryAnimation) => PasscodeScreen(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        circleUIConfig: circleUIConfig,
        keyboardUIConfig: keyboardUIConfig,
        passwordEnteredCallback: (pin) {
          //_verificationNotifier.add(true);
          widget._settingsBloc.setPassword(pin);
          widget._authBloc.authenticate(pin);
          _retry();
          //Navigator.of(context, rootNavigator: true).pop();
        },
        cancelButton: cancelButton,
        deleteButton: Text(
          'Delete',
          style: const TextStyle(fontSize: 16, color: Colors.white),
          semanticsLabel: 'Delete',
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
        cancelCallback: () => {},
        digits: digits,
        passwordDigits: 4,
        shouldTriggerVerification: _verificationNotifier.stream,
      ),
    ));
  }

  Future<void> _presentDialog(BuildContext widgetContext,
      {String message, String action}) async {
    await showDialog(
      context: widgetContext,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(message),
        content: TextField(
          controller: _writeController,
          onChanged: widget._settingsBloc.setPassword,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(action),
            onPressed: () {
              widget._authBloc.authenticate(_writeController.value.text);
              _retry();
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );
  }

  Widget _generateMessageWidget(String message) => Center(
      child: Text(message,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'Europe_Ext',
          )));

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          color: Colors.black,
          child: StreamBuilder<DeviceConnectionState>(
            stream: widget._deviceBloc.connectionState,
            initialData: DeviceConnectionState.normalBTState(
                state: PeripheralConnectionState.disconnected),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return snapshot.data.when(normalBTState: (state) {
                  switch (state) {
                    case PeripheralConnectionState.connected:
                      _connected = true;
                      if (widget._settingsBloc.isPasswordRemembered() == true) {
                        widget._deviceBloc.deviceReady.listen((event) {
                          if (event == true) {
                            final password = widget._settingsBloc.getPassword();
                            print('Password is $password');
                            widget._authBloc.authenticate(password);
                          }
                        });
                        return Container();
                      } else
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => _showLockScreen(
                                  context,
                                  title: 'Enter your pin',
                                  opaque: true,
                                  cancelButton: Text(
                                    'Cancel',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                    semanticsLabel: 'Cancel',
                                  ),
                                ));
                      return Container();
                      break;
                    case PeripheralConnectionState.connecting:
                      print('CONNECTING IN BLE');
                      return Center(child: CircularProgressIndicator());
                    case PeripheralConnectionState.disconnected:
                      return _generateMessageWidget('disconnected');
                    default:
                      return Container();
                  }
                }, bleException: (_) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _presentDialog(context,
                        message: 'BLE exception', action: 'Retry');
                  });
                  return Container();
                  // TODO: show dialog which says "try again". Should call .connect()
                });
              } else
                return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      );
}
