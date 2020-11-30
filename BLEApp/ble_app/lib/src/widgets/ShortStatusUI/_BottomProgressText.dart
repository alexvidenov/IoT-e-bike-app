import 'package:flutter/material.dart';

class ProgressText extends StatelessWidget {
  final String title, content;

  const ProgressText({this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
                fontFamily: 'Europe_Ext'),
          ),
          Text(
            content,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                fontFamily: 'Europe_Ext'),
          ),
        ],
      ),
    );
  }
}
