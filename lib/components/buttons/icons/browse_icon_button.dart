import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:plansy_flutter_app/screens/attractions/browse_screen.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

IconButton browseIconButton(BuildContext context, bool isBrowse) {
  return IconButton(
    icon: isBrowse ? buildMarkedIcon() : Icon(Icons.search),
    onPressed: () => goToBrowseIfNotThere(isBrowse, context),
    color: kSecondaryColor,
  );
}

IconShadowWidget buildMarkedIcon() {
  return IconShadowWidget(
    Icon(Icons.search, color: Colors.black12),
    shadowColor: kPrimaryColor.shade300,
  );
}

void goToBrowseIfNotThere(bool isBrowse, BuildContext context) {
  if (!isBrowse) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BrowseScreen(isAdmin: false)));
  }
}
