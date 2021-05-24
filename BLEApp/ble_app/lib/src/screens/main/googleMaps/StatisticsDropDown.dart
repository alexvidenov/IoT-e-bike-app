import 'package:ble_app/src/modules/dataClasses/routeFileModel.dart';
import 'package:flutter/material.dart';

class StatisticsDropDown extends StatefulWidget {
  final RouteFileModel _routeFileModel;

  const StatisticsDropDown(this._routeFileModel);

  @override
  _StatisticsDropDownState createState() => _StatisticsDropDownState();
}

class _StatisticsDropDownState extends State<StatisticsDropDown>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  bool _showed = false;

  void _runExpandCheck() =>
      _showed ? _controller.forward() : _controller.reverse();

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _runExpandCheck();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      color: Colors.black26,
                      offset: Offset(0, 2))
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.stacked_bar_chart,
                    color: Color(0xFF307DF1),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      _showed = !_showed;
                      _runExpandCheck();
                      setState(() {});
                    },
                    child: Text(
                      'Statistics',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  )),
                  Align(
                    alignment: Alignment(1, 0),
                    child: Icon(
                      _showed ? Icons.arrow_drop_down : Icons.arrow_right,
                      color: Color(0xFF307DF1),
                      size: 15,
                    ),
                  ),
                ],
              ),
            ),
            SizeTransition(
                axisAlignment: 1.0,
                sizeFactor: _animation,
                child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4,
                            color: Colors.black26,
                            offset: Offset(0, 4))
                      ],
                    ),
                    child: widget._routeFileModel != null
                        ? Column(
                            children: [
                              _buildSingleStatistic(
                                description: 'Route name',
                                title: widget._routeFileModel.name ?? '',
                              ),
                              Divider(
                                color: Colors.grey.shade300,
                                height: 1,
                              ),
                              _buildSingleStatistic(
                                description: 'Start time',
                                title: widget._routeFileModel.startedAt ?? '',
                              ),
                              Divider(
                                color: Colors.grey.shade300,
                                height: 1,
                              ),
                              _buildSingleStatistic(
                                description: 'Stop time',
                                title: widget._routeFileModel.finishedAt ?? '',
                              ),
                              Divider(
                                color: Colors.grey.shade300,
                                height: 1,
                              ),
                              _buildSingleStatistic(
                                description: 'Track length',
                                title:
                                    (widget._routeFileModel.length.toString() +
                                            ' km') ??
                                        '',
                              ),
                              Divider(
                                color: Colors.grey.shade300,
                                height: 1,
                              ),
                              _buildSingleStatistic(
                                description: 'Consumed power',
                                title: (widget._routeFileModel.consumed
                                            .toString() +
                                        ' wh') ??
                                    '',
                              ),
                            ],
                          )
                        : Center(
                            child: Text(
                              'No route loaded',
                              style: TextStyle(fontSize: 20),
                            ),
                          ))),
          ],
        ),
      );

  Widget _buildSingleStatistic({String title, String description}) => Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 5, bottom: 5),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.grey[200], width: 1)),
                  ),
                  child: Column(children: [
                    if (description != null)
                      Text(description + ": ",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis),
                    Text(title,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 20),
                        maxLines: 3,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis),
                  ])),
            ),
          ],
        ),
      );
}
