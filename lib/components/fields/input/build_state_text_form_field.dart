import 'package:flutter/material.dart';

TextFormField buildStateTextFormField(
    {bool isEnabled, TextEditingController controller, Function onSaved}) {
  return TextFormField(
    enabled: isEnabled ?? true,
    controller: controller ?? null,
    onSaved: onSaved,
    onChanged: (value) => null,
    validator: (value) => null,
    decoration: InputDecoration(
      labelText: "State",
      labelStyle: TextStyle(color: Colors.black),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}
