import 'package:flutter/material.dart';

Future<void> showRemoveAttractionDialog(
    BuildContext context, Function removeFromListCallback) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete it?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              removeFromListCallback();
              Navigator.of(context).pop();
            },
          ),
          TextButton(child: Text('No'), onPressed: () => Navigator.of(context).pop()),
        ],
      );
    },
  );
}
