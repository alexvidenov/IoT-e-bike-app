import 'package:ble_app/src/blocs/btConnectionBloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:visibility_detector/visibility_detector.dart';

abstract class VisibleWidget extends StatefulWidget {
  final String name;

  VisibleWidget({@required this.name});

  void onResume();

  void onPause();

  Widget buildWidget();

  void onCreate();

  @override
  _VisibleWidgetState createState() => _VisibleWidgetState();
}

class _VisibleWidgetState extends State<VisibleWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.widget.onCreate();
  }

  @override
  bool get wantKeepAlive => true;

  bool _isDisposed = false;

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
    var visiblePercentage = info.visibleFraction * 100;
    if (visiblePercentage < 1) {
      // widget is disposed
      this.widget.onPause();
      _isDisposed = true;
    } else if (visiblePercentage > 1 && _isDisposed == true) {
      // widget comes into foreground
      this.widget.onResume();
      _isDisposed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: VisibilityDetector(
        key: Key(widget.name),
        onVisibilityChanged: (VisibilityInfo info) =>
            _onVisibilityHandler(info),
        child: this.widget.buildWidget(), // the actual different implementation
      ),
    );
  }
}
