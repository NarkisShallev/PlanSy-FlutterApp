import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

TextFormField buildDescriptionTextFormField(
    {Function onSaved, bool isUpdate, String initialValue, Function onChanged}) {
  return TextFormField(
    style: isUpdate ? k12BlackStyle : null,
    initialValue: initialValue,
    onSaved: onSaved,
    onChanged: isUpdate ? onChanged : (value) => null,
    validator: (value) {
      if (value.isEmpty) {
        return kDescriptionNullError;
      }
      return null;
    },
    maxLines: 4,
    decoration: InputDecoration(
      labelText: isUpdate ? "" : "* Description",
      labelStyle: TextStyle(color: Colors.black),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}
