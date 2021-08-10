import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/suffixes/custom_suffix_icon.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

TextFormField buildPasswordTextFormField(
    {Function onSaved, Function setChangeShowSpinner, Function setPassword}) {
  return TextFormField(
    style: TextStyle(color: Colors.black),
    obscureText: true,
    onSaved: onSaved,
    onChanged: (value) {
      if (setPassword != null) {
        setPassword(value);
      }
      return null;
    },
    validator: (value) {
      if (value.isEmpty) {
        setChangeShowSpinner(false);
        return kPassNullError;
      }
      if (value.length < 6) {
        setChangeShowSpinner(false);
        return kShortPassError;
      }
      return null;
    },
    decoration: InputDecoration(
      labelText: "* Password",
      labelStyle: TextStyle(color: Colors.black),
      hintText: "Enter your password",
      hintStyle: TextStyle(color: Colors.black54),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: CustomSuffixIcon(icon: Icons.lock_outline, color: Colors.black),
    ),
  );
}
