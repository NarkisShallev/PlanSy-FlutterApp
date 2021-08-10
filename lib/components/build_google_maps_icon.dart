import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

InkWell buildGoogleMapsIcon({Function onTap}) {
  return InkWell(
    onTap: onTap,
    child: Image(
      height: getProportionateScreenHeight(50),
      image: AssetImage("images/google_maps_icon_transparent.png"),
      fit: BoxFit.fill,
    ),
  );
}
