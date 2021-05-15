import 'package:flutter/material.dart';

class ForbiddenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Locked'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock,
              size: 250,
              color: Colors.blueGrey,
            ),
            const Text(
              'You have no right to access this page. Contact us for more information',
              maxLines: 2,
            )
          ],
        )),
      );
}
