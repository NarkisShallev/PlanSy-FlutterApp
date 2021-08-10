import 'package:flutter/material.dart';

IconButton arrowIconButton(Function onPressedArrow, BuildContext context, Color iconsColor) {
  return IconButton(
    icon: Icon(Icons.arrow_back, color: iconsColor),
    onPressed: () {
      if (onPressedArrow != null) {
        onPressedArrow();
      }
      Navigator.of(context).pop();
    },
  );
}
