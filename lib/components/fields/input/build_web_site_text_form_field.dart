import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

TextFormField buildWebSiteTextFormField(
    {Function onSaved, bool isUpdate, String initialValue, Function onChanged}) {
  return TextFormField(
    style: isUpdate ? k12BlackStyle : null,
    initialValue: initialValue,
    onSaved: onSaved,
    onChanged: isUpdate ? onChanged : (value) => null,
    validator: (value) {
      if (value.isNotEmpty) {
        if (!value.startsWith("https://")) {
          return kHttpsError;
        }
      }
      return null;
    },
    decoration: InputDecoration(
      labelText: isUpdate ? "" : "Web site",
      labelStyle: TextStyle(color: Colors.black),
      hintText: "https:// ...",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}
