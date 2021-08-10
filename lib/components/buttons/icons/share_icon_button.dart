import 'package:flutter/material.dart';

IconButton shareIconButton(Function shareOnPressed, Color iconsColor) {
  return IconButton(
    icon: Icon(Icons.share, color: iconsColor),
    onPressed: shareOnPressed,
  );
}
