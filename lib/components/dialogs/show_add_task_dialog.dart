import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

Future<void> showAddTaskDialog(BuildContext context, String newTaskTitle) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: buildTitle(),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Theme(
                data: ThemeData(
                  inputDecorationTheme: InputDecorationTheme(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(45),
                        vertical: getProportionateScreenWidth(20)),
                    enabledBorder: null,
                    focusedBorder: null,
                    border: null,
                  ),
                ),
                child: TextField(
                  autofocus: true,
                  textAlign: TextAlign.center,
                  onChanged: (newText) => newTaskTitle = newText,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Add',
              style: TextStyle(color: kPrimaryColor),
            ),
            onPressed: () {
              int tripIdx = Provider.of<Data>(context, listen: false).tripIndex;
              if (newTaskTitle != null) {
                Provider.of<Data>(context, listen: false).addTask(tripIdx, newTaskTitle);
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Text buildTitle() => Text('Add', textAlign: TextAlign.center);
