import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

Image buildBigAttractionImage({Attraction attraction}) {
  return Image(
    width: double.infinity,
    height: getProportionateScreenHeight(280),
    image: attraction.imageSrc == "default_image.png"
        ? AssetImage("images/" + attraction.imageSrc)
        : NetworkImage(attraction.imageSrc),
    fit: BoxFit.fill,
  );
}