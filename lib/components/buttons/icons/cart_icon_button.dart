import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:plansy_flutter_app/screens/cart/cart_screen.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

IconButton cartIconButton(BuildContext context, bool isCart) {
  return IconButton(
    icon: isCart ? buildMarkedIcon() : Icon(Icons.map),
    onPressed: () => goToCartIfNotThere(isCart, context),
    color: kSecondaryColor,
  );
}

IconShadowWidget buildMarkedIcon() {
  return IconShadowWidget(
    Icon(Icons.map, color: Colors.black12),
    shadowColor: kPrimaryColor.shade300,
  );
}

void goToCartIfNotThere(bool isCart, BuildContext context) {
  if (!isCart) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CartScreen()),
    );
  }
}
