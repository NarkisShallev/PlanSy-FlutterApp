import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:provider/provider.dart';

Future<void> showRemoveAttractionDialog(
    BuildContext context, Function removeFromListCallback, Attraction attraction) async {
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
              if (attraction!=null){
                Provider.of<Data>(context, listen: false).deleteAttractionFromFireBase(attraction);
              }
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
