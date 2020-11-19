import 'package:ble_app/src/screens/fullStatusPage.dart';
import 'package:ble_app/src/screens/googleMapsPage.dart';
import 'package:ble_app/src/screens/shortStatusPage.dart';
import 'package:ble_app/src/widgets/navigationDrawer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Home"),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Short Status",
                  icon: Icon(Icons.home),
                ),
                Tab(
                  text: "Full Status",
                  icon: Icon(Icons.dashboard),
                ),
                Tab(
                  text: "Map",
                  icon: Icon(Icons.zoom_out_map),
                )
              ],
            ),
          ),
          drawer: NavigationDrawer(),
          body: TabBarView(
            children: [
              DeviceScreen(),
              FullStatusPage(),
              MapPage(title: "Location"),
            ],
          ),
        ));
  }
}
