import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/suffixes/custom_suffix_icon.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

TextFormField buildConfirmPasswordFormField({Function onSaved, String password, Function setChangeShowSpinner}) {
  return TextFormField(
    obscureText: true,
    onSaved: onSaved,
    onChanged: (value) => null,
    validator: (value) {
      if (password != value) {
        setChangeShowSpinner(false);
        return kMatchPassError;
      }
      return null;
    },
    decoration: InputDecoration(
      labelText: "* Confirm password",
      labelStyle: TextStyle(color: Colors.black),
      hintText: "Re-enter your password",
      hintStyle: TextStyle(color: Colors.black54),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: CustomSuffixIcon(icon: Icons.lock_outline, color: Colors.black),
    ),
  );
}
