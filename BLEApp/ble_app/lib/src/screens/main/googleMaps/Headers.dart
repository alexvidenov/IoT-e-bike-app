import 'package:flutter/material.dart';

class BottomSheetHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        height: 5,
        width: 30,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
      );
}

class LastRoutesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Saved routes",
              style: TextStyle(fontSize: 22, color: Colors.black45)),
          SizedBox(width: 8),
          Container(
            height: 24,
            width: 24,
            child: Icon(Icons.arrow_drop_down_circle,
                size: 12, color: Colors.black54),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16)),
          ),
        ],
      );
}
