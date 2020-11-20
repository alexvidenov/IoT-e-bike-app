import 'package:ble_app/src/blocs/btConnectionBloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:visibility_detector/visibility_detector.dart';

abstract class VisibleWidget extends StatefulWidget {
  const VisibleWidget({@required Key key}) : super(key: key);

  Widget buildWidget();

  void onResume();

  void onPause();

  void onCreate();

  void onDestroy();

  @override
  _VisibleWidgetState createState() => _VisibleWidgetState();
}

class _VisibleWidgetState extends State<VisibleWidget>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  bool _isVisible = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    this.widget.onCreate();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _isVisible &&
        widget.onResume != null) {
      widget.onResume();
    }

    if (state == AppLifecycleState.paused &&
        _isVisible &&
        widget.onPause != null) {
      widget.onPause();
    }
  }

  Future<bool> _onWillPop() {
    final bloc = GetIt.I<ConnectionBloc>();
    return showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Are you sure?',
                  style: TextStyle(fontFamily: 'Europe_Ext')),
              content: Text('Do you want to disconnect device and go back?',
                  style: TextStyle(fontFamily: 'Europe_Ext')),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No')),
                FlatButton(
                    onPressed: () {
                      bloc.disconnect();
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Yes')),
              ],
            ) ??
            false);
  }

  _onVisibilityHandler(VisibilityInfo info) {
    _isVisible = info.visibleFraction > 0;
    if (_isVisible && widget.onResume != null) {
      widget.onResume();
    }

    if (!_isVisible && widget.onPause != null) {
      widget.onPause();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: VisibilityDetector(
        key: widget
            .key, // this makes sure that the VisibilityDetector acts separately for every widget.
        onVisibilityChanged: (VisibilityInfo info) =>
            _onVisibilityHandler(info),
        child: this.widget.buildWidget(), // the actual different implementation
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    this.widget.onDestroy();
    super.dispose();
  }
}
