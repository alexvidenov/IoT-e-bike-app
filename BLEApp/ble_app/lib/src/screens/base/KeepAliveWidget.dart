import 'package:flutter/material.dart';

abstract class KeepAliveWidget extends StatefulWidget {
  Widget buildWidget(BuildContext context);

  const KeepAliveWidget();

  @override
  _KeepAliveWidgetState createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.buildWidget(context);
  }

  @override
  bool get wantKeepAlive => true;
}
