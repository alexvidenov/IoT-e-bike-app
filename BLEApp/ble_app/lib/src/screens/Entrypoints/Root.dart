import 'package:ble_app/src/blocs/PageManager.dart';
import 'package:ble_app/src/blocs/authBloc.dart';
import 'package:ble_app/src/blocs/settingsBloc.dart';
import 'package:ble_app/src/di/serviceLocator.dart';
import 'package:ble_app/src/sealedStates/authState.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../../listeners/authStateListener.dart';
import 'Mode.dart';

class RootPage extends StatelessWidget {
  final PageManager _manager;

  const RootPage(this._manager);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: ResponsiveWrapper.builder(widget,
            maxWidth: 1200,
            minWidth: 480,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ]),
      ),
      color: Colors.lightBlue,
      theme: ThemeData(fontFamily: 'Europe_Ext'),
      home: MainNavigatorEntryPoint(this._manager),
    );
  }
}

class MainNavigatorEntryPoint extends StatelessWidget {
  final PageManager _pageManager;

  const MainNavigatorEntryPoint(this._pageManager);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Page>>(
      stream: _pageManager.pages.stream,
      initialData: _pageManager.pages.stream.value,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          print('BUILDIGN NAVIGATOR WITH PAGES =>');
          print(snapshot.data);
          return WillPopScope(
              onWillPop: () async {
                print('UPPER WILLPOPSCOE');
                return !await _pageManager.navigatorKey.currentState.maybePop();
              },
              child: Navigator(
                  key: _pageManager.navigatorKey,
                  pages: snapshot.data,
                  onPopPage: (route, result) =>
                      _onPopPage(route, result, _pageManager)));
        } else
          return Container();
      },
    );
  }

  bool _onPopPage(
      Route<dynamic> route, dynamic result, PageManager pageManager) {
    print('POPPING =>');
    print(route.settings);
    pageManager.didPop(route.settings, result);
    return route.didPop(result);
  }
}

class DetermineEndpointWidget extends StatefulWidget {
  final AuthBloc _auth;
  final SettingsBloc _settingsBloc;

  const DetermineEndpointWidget(this._auth, this._settingsBloc);

  @override
  _DetermineEndpointWidgetState createState() =>
      _DetermineEndpointWidgetState();
}

class _DetermineEndpointWidgetState extends State<DetermineEndpointWidget>
    with AuthStateListener {
  AuthState currAuthState;

  bool isFirstTime = false;

  @override
  initState() {
    super.initState();
    widget._auth.setListener(this);
    if (widget._settingsBloc.isFirstTime()) isFirstTime = true;
  }

  void _chosen(Mode mode) {
    if (mode == Mode.Account)
      setState(() {
        isFirstTime = false;
        currAuthState = AuthState.loggedOut();
      });
    else if (mode == Mode.Incognito) {
      isFirstTime = false;
      print('BRO');
      widget._auth.signInAnonymously();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isFirstTime) {
      $<PageManager>().openWelcomeScreen(this._chosen);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isFirstTime) {
      if (currAuthState != null) {
        currAuthState.maybeWhen(
            authenticated: (_) => WidgetsBinding.instance
                .addPostFrameCallback((_) => $<PageManager>().openBleApp()),
            loggedOut: () => WidgetsBinding.instance.addPostFrameCallback(
                (_) => $<PageManager>().openAuthWrapper(this._chosen)),
            fetchingUserInformation: () => {},
            orElse: () => {});
        return Center(child: CircularProgressIndicator());
      } else
        return Container();
    } else
      return Container();
  }

  @override
  onAuthStateChanged(AuthState authState) => setState(() {
        this.currAuthState = authState;
        print('AUTH => $authState'); // the rebuild from here fucked up the key
      });
}
