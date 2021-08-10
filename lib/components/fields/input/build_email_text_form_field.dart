import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/suffixes/custom_suffix_icon.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

TextFormField buildEmailTextFormField({Function onSaved, Function setChangeShowSpinner}) {
  return TextFormField(
    keyboardType: TextInputType.emailAddress,
    onSaved: onSaved,
    onChanged: (value) => null,
    validator: (value) {
      if (value.isEmpty) {
        setChangeShowSpinner(false);
        return kEmailNullError;
      }
      if (!emailValidatorRegExp.hasMatch(value)) {
        setChangeShowSpinner(false);
        return kInvalidEmailError;
      }
      return null;
    },
    decoration: InputDecoration(
      labelText: "* Email",
      labelStyle: TextStyle(color: Colors.black),
      hintText: "Enter your email",
      hintStyle: TextStyle(color: Colors.black54),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: CustomSuffixIcon(icon: Icons.mail_outline, color: Colors.black),
    ),
  );
}
