import 'package:flutter/material.dart';

class ProgressText extends StatelessWidget {
  final String title, content, measurementUnit;
  final bool compact;

  const ProgressText({
    @required this.title,
    this.content,
    this.measurementUnit,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
              content ?? '',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: compact ? 25.0 : 47.0,
                  fontFamily: 'Europe_Ext'),
            ),
            Text(
              measurementUnit ?? '',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 20.0,
                  fontFamily: 'Europe_Ext'),
            )
          ],
        ),
      );
}
