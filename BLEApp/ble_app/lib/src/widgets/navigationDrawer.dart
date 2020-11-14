import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {               
    return Drawer(                              
      child: ListView(    
        padding: EdgeInsets.zero,
        children: <Widget>[                
          _createHeader(),
          _createDrawerItem(
            icon: Icons.home,
            text: 'Home',
          ),
          Divider(),
          _createDrawerItem(
            icon: Icons.settings,
            text: 'Settings',
          ),
          Divider(),
          ListTile(
            title: Text('Vertion 0.0.1. All rights reserved. '),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {               
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                    'path/to/header_background.png'))), // think of a real picture later on
        child: Stack(children: <Widget>[           
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Bluetooth low energy app",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}