import 'package:ble_app/src/modules/dataClasses/routeFileModel.dart';
import 'package:flutter/material.dart';

import 'CachedRouteChosenNotification.dart';

class LastRouteView extends StatelessWidget {
  final RouteFileModel model;
  final Function(String) onDelete;
  final Function(String, String) onEdit;

  const LastRouteView({Key key, this.model, this.onDelete, this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Column(children: [
        ListTile(
            tileColor: Colors.black12,
            title: Card(
              color: Colors.lightBlueAccent,
              elevation: 12.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              margin: const EdgeInsets.all(10),
              child: InkWell(
                splashColor: Colors.deepPurple,
                onTap: () => CachedRouteChosenNotification(model.startedAt)
                    .dispatch(context),
                child: Container(
                  width: 300,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Route: ' + model.name,
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(model.startedAt, style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                    child: ListTile(
                        leading: Icon(Icons.edit_sharp),
                        title: Text('Rename'),
                        onTap: () => onEdit(model.name, model.startedAt))),
                PopupMenuItem(
                    child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete'),
                        onTap: () {
                          onDelete(model.startedAt);
                          Navigator.of(context).pop();
                        }))
              ],
              tooltip: "Tap to view options",
            )),
        const SizedBox(
          height: 10,
        ),
      ]);
}
