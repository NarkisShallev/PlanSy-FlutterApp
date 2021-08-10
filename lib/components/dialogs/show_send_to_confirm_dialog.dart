import 'package:flutter/material.dart';

Future<void> showSendToConfirmDialog({BuildContext context, int numOfPops}) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Your proposal has been submitted for administrator approval.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              for (int i = 0; i < numOfPops; i++) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      );
    },
  );
}
