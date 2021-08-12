import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

Future<Address> findFirstAddressFromAddress(String address) async {
  try {
    List<Address> location = await Geocoder.local.findAddressesFromQuery(address);
    return location.first;
  } catch (e) {
    return null;
  }
}

Future<Address> findFirstAddressFromCoordinates(Coordinates coordinates) async {
  List<Address> location = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  return location.first;
}

double getDistanceInKm(Coordinates point1, Coordinates point2) {
  double distanceInMeters = Geolocator.distanceBetween(
      point1.latitude, point1.longitude, point2.latitude, point2.longitude);
  print("----distInMeters $distanceInMeters");
  print("----distInKMeters ${distanceInMeters / 1000}");
  return distanceInMeters / 1000;
}

TimeOfDay kmToTime(double km) {
  int avgKmPerHour = kavgKmPerHour;
  if (km / avgKmPerHour > 24) {
    print("OVER A DAY");
  }
  int hour = km ~/ avgKmPerHour;
  int minute = (((km % avgKmPerHour) / 80) * 60).toInt();
  return TimeOfDay(hour: hour, minute: minute);
}

Future<Position> getCurrentPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  Position position = await Geolocator.getCurrentPosition();
  return position;
}
