import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

TextFormField buildNumOfHoursPerDayTextFormField(
    {Function onSaved, String initialValue, bool isEnabled, bool isDetails}) {
  return TextFormField(
    inputFormatters: [
      // ignore: deprecated_member_use
      WhitelistingTextInputFormatter(RegExp("[0-9.]")),
    ],
    initialValue: initialValue ?? "",
    enabled: isEnabled ?? true,
    onSaved: onSaved,
    onChanged: (value) => null,
    validator: (value) {
      if (value.isEmpty) {
        return kNumberOfHoursPerDayNullError;
      }
      if ((value.isNotEmpty && double.tryParse(value) == null) || (value.isNotEmpty && double.tryParse(value)>24)) {
        return kInvalidNumberError;
      }
      return null;
    },
    decoration: InputDecoration(
      labelText: isDetails && !isEnabled ? "Number of hours per day" : "* Number of hours per day",
      labelStyle: TextStyle(color: Colors.black),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixText: "hours",
    ),
  );
}
