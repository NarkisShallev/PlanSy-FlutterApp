import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:plansy_flutter_app/screens/home/home_screen.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

IconButton homeIconButton(BuildContext context, bool isHome) {
  return IconButton(
    icon: isHome ? buildMarkedIcon() : Icon(Icons.home),
    onPressed: () => goToHomeIfNotThere(isHome, context),
    color: kSecondaryColor,
  );
}

IconShadowWidget buildMarkedIcon() {
  return IconShadowWidget(
    Icon(Icons.home, color: Colors.black12),
    shadowColor: kPrimaryColor,
  );
}

void goToHomeIfNotThere(bool isHome, BuildContext context) {
  if (!isHome) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
