import 'dart:async';

import 'package:ble_app/src/blocs/PageManager.dart';
import 'package:ble_app/src/blocs/btAuthenticationBloc.dart';
import 'package:ble_app/src/blocs/deviceBloc.dart';
import 'package:ble_app/src/blocs/prefs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';

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

  const BLEAuthenticationScreen(
      this._deviceBloc, this._authBloc, this._settingsBloc);

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
  void initState() {
    super.initState();
    print('INIT STATE CALLED');
    widget._deviceBloc.stopScan(); // this is not needed for sure
    widget._authBloc.create();
    _listenToAuthBloc();
    widget._deviceBloc.connect();
    _handleBLEError();
  }

  _handleBLEError() => Future.delayed(Duration(seconds: 7), () {
        if (!_connected) widget._deviceBloc.connect();
      });

  @override
  dispose() {
    super.dispose();
    widget._deviceBloc.dispose();
    _streamSubscriptionAuth.cancel();
  }

  void _listenToAuthBloc() =>
      _streamSubscriptionAuth = widget._authBloc.stream.listen((event) {
        event.when(
            btAuthenticated: () {
              this._verificationNotifier.add(true);
              _isAuthenticated = true;
              widget._authBloc
                  .setMacAddress(widget._deviceBloc.device.value.id);
              widget._authBloc.pause();
              $<PageManager>().openParameters();
            },
            failedToBTAuthenticate: (reason) => _presentDialog(context,
                message: reason.toString(), action: 'TRY AGAIN'));
      });

  _retry() => Future.delayed(Duration(seconds: 2), () {
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
          print('AUTHENTICATING BOY: ' + DateTime.now().toString());
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
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          actions: [
            RaisedButton(
                color: Colors.transparent,
                child: Text('Switch offline mode',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 2,
                        fontFamily: 'Europe_Ext')),
                onPressed: () => $<PageManager>().openOfflineHome()),
          ],
        ),
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
                      if (widget._settingsBloc.isPasswordRemembered()) {
                        print('PASSWORD REMEMBERED');
                        widget._deviceBloc.deviceReady.listen((event) {
                          if (event) {
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
