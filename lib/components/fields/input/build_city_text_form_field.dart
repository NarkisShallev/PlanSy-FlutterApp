import 'package:flutter/material.dart';

TextFormField buildCityTextFormField(
    {bool isEnabled, TextEditingController controller, Function onSaved}) {
  return TextFormField(
    enabled: isEnabled ?? true,
    controller: controller ?? null,
    onSaved: onSaved,
    onChanged: (value) => null,
    validator: (value) => null,
    decoration: InputDecoration(
      labelText: "City",
      labelStyle: TextStyle(color: Colors.black),
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}
