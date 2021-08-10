import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:plansy_flutter_app/screens/wishlist/wishlist_screen.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

IconButton wishListIconButton(BuildContext context, bool isWishList) {
  return IconButton(
    icon: isWishList ? buildMarkedIcon() : Icon(Icons.favorite),
    onPressed: () => goToWishListIfNotThere(isWishList, context),
    color: kSecondaryColor,
  );
}

IconShadowWidget buildMarkedIcon() {
  return IconShadowWidget(
    Icon(Icons.favorite, color: Colors.black12),
    shadowColor: kPrimaryColor.shade300,
  );
}

void goToWishListIfNotThere(bool isWishList, BuildContext context) {
  if (!isWishList) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => WishListScreen()));
  }
}
