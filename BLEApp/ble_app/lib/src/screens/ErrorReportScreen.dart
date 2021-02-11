import 'package:flutter/material.dart';

class ErrorReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Compose message',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            IconButton(icon: Icon(Icons.message), onPressed: () {}),
          ],
        ),
        body: Container());
  }
}
