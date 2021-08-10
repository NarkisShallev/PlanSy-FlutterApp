import 'package:flutter/material.dart';

IconButton editIconButton(Function onPressedEdit, Color iconsColor) {
  return IconButton(
    icon: Icon(Icons.edit, color: iconsColor),
    onPressed: () => onPressedEdit(),
  );
}
