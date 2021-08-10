import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

TextFormField buildTitleTextFormField(
    {String initialValue, bool isEnabled, Function onSaved, bool isDetails}) {
  return TextFormField(
    inputFormatters: [
      LengthLimitingTextInputFormatter(18),
      // ignore: deprecated_member_use
      WhitelistingTextInputFormatter(RegExp("[0-9a-zA-Z !?&*()\"'/:,-_]")),
    ],
    initialValue: initialValue ?? "",
    enabled: isEnabled ?? true,
    onSaved: onSaved,
    onChanged: (value) => null,
    validator: (value) {
      if (value.isEmpty) {
        return kTitleNullError;
      }
      return null;
    },
    decoration: InputDecoration(
      labelText: isDetails && !isEnabled ? "Title" : "* Title",
      labelStyle: TextStyle(color: Colors.black),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}
