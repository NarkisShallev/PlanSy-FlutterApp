import 'package:flutter/material.dart';

IconButton saveIconButton(Function onPressedSave, Color iconsColor) {
  return IconButton(
    icon: Icon(Icons.save_outlined, color: iconsColor),
    onPressed: () => onPressedSave(),
  );
}