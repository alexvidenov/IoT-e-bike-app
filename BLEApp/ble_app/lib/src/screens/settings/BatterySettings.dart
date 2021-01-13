import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BatterySettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text('Battery Settings'),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: Text('1'),
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('VMAX_CONST : '),
                              Text('24 V')
                              // here check with smt like: prefs.maxCellVoltage ?? 24.
                            ]),
                        subtitle: Text('Max cell voltage'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => {} // stuff
                        ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: Text('1'),
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('VMAX_CONST : '),
                              Text('24 V')
                              // here check with smt like: prefs.maxCellVoltage ?? 24.
                            ]),
                        subtitle: Text('Max cell voltage'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => {} // stuff
                        ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: Text('1'),
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('VMAX_CONST : '),
                              Text('24 V')
                              // here check with smt like: prefs.maxCellVoltage ?? 24.
                            ]),
                        subtitle: Text('Max cell voltage'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: () => {} // stuff
                        ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
