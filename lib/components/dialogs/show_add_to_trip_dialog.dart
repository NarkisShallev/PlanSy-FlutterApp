import 'package:flutter/material.dart';

Future<void> showAddToTripDialog(BuildContext context, bool isPressed) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              isPressed
                  ? Text('This attraction is already in your cart.')
                  : Text('The attraction has been successfully added to your cart.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(child: Text('OK'), onPressed: () => Navigator.pop(context)),
        ],
      );
    },
  );
}
