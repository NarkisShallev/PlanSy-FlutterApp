import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/screens/login/sign_in_screen.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

Future<void> showConfirmEmailDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('An email has just been sent to you.'),
              SizedBox(height: getProportionateScreenHeight(15)),
              Text('Click the link provided to complete the operation and then log in.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Sign in'),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen())),
          ),
        ],
      );
    },
  );
}
