import 'package:flutter/material.dart';

TextFormField buildCountryTextFormField(
    {bool isEnabled, TextEditingController controller, Function onSaved}) {
  return TextFormField(
    enabled: isEnabled ?? true,
    controller: controller ?? null,
    onSaved: onSaved,
    onChanged: (value) => null,
    validator: (value) => null,
    decoration: InputDecoration(
      labelText: "Country",
      labelStyle: TextStyle(color: Colors.black),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}
