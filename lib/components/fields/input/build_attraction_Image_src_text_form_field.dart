import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

TextFormField buildImageSrcTextFormField({Function onSaved}) {
  return TextFormField(
    onSaved: onSaved,
    onChanged: (value) => null,
    validator: (value) {
      if (value.isNotEmpty){
        if (!value.startsWith("https://")) {
          return kHttpsError;
        }
        if (!value.endsWith("jpg") && !value.endsWith("jpeg") && !value.endsWith("png")) {
          return kImageFormatError;
        }
      }
      return null;
    },
    decoration: InputDecoration(
      labelText: "image URL",
      labelStyle: TextStyle(color: Colors.black),
      hintText: "https:// ... .jpg or .jpeg or .png",
      floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}
