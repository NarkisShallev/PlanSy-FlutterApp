import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

TextFormField buildAttractionNameTextFormField({Function onSaved}) {
  return TextFormField(
    inputFormatters: [
      LengthLimitingTextInputFormatter(17),
      // ignore: deprecated_member_use
      WhitelistingTextInputFormatter(RegExp("[0-9a-zA-Z !?&*()\"'/:,-_]")),
    ],
    onSaved: onSaved,
    onChanged: (value) => null,
    validator: (value) {
      if (value.isEmpty) {
        return kAttractionNameNullError;
      }
      return null;
    },
    maxLines: 1,
    decoration: InputDecoration(
      labelText: "* Name",
      labelStyle: TextStyle(color: Colors.black),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}
