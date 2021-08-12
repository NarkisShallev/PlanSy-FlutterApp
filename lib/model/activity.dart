import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

class Activity {
  final String hour;
  final String attractionName;
  final String imageSrc;
  final String address;
  final Coordinates latLngLocation;
  final String isNeedToBuyTicketsInAdvance;
  final TimeOfDay duration;

  Activity({
    @required this.hour,
    @required this.attractionName,
    @required this.imageSrc,
    @required this.address,
    this.latLngLocation,
    @required this.isNeedToBuyTicketsInAdvance,
    @required this.duration,
  });
}
