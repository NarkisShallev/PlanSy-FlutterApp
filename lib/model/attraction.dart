import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';

class Attraction {
  // existing = 0, new = 1, updated = 2
  final int status;
  int priority;

  final String name;
  final String imageSrc;
  final String category;
  final String address;
  Coordinates latLngLocation;
  final String country; //TODO: update
  final String description;

  // format: '08:00-17:00'
  final TimeOfDay openingTime;
  final TimeOfDay closingTime;

  final String webSite;
  final String pricing;
  final String isNeedToBuyTickets;

  // children? couples? ...
  final String suitableFor;
  final String suitableSeason;
  final TimeOfDay duration;

  String recommendations;
  String numOfReviews;
  String rating;

  // ID in DB
  String _id;

  Attraction(
      {@required this.status,
      @required this.priority,
      @required this.name,
      @required this.imageSrc,
      @required this.category,
      @required this.address,
      @required this.country,
      @required this.description,
      @required this.openingTime,
      @required this.closingTime,
      @required this.webSite,
      @required this.pricing,
      @required this.isNeedToBuyTickets,
      @required this.suitableFor,
      @required this.suitableSeason,
      @required this.duration,
      @required this.recommendations,
      @required this.numOfReviews,
      @required this.rating,
      @required this.latLngLocation});

  void setID(String id) {
    _id = id;
  }

  String getID() {
    return _id;
  }

  void setLatLngLocation(Coordinates coordinates) => this.latLngLocation = coordinates;

  // that is the original attraction checking if it wsa updated
  Map<String, dynamic> checkForUpdates(Attraction other) {
    Map<String, dynamic> changes = {};
    if (this.duration != other.duration) {
      changes["Duration"] = TimeOfDayExtension(other.duration).str();
    }
    if (this.pricing != other.pricing) {
      changes["Payment"] = other.pricing;
    }
    if (this.isNeedToBuyTickets != other.isNeedToBuyTickets) {
      changes["IsNeedToBuyTicketsInAdvance"] = other.isNeedToBuyTickets;
    }
    if (this.category != other.category) {
      changes["Category"] = other.category;
    }
    if (this.openingTime != other.openingTime) {
      changes["OpeningTime"] = TimeOfDayExtension(other.openingTime).str();
    }
    if (this.closingTime != other.closingTime) {
      changes["ClosingTime"] = TimeOfDayExtension(other.closingTime).str();
    }
    if (this.suitableSeason != other.suitableSeason) {
      changes["SuitableWeather"] = other.suitableSeason;
    }
    if (this.suitableFor != other.suitableFor) {
      changes["SuitableFor"] = other.suitableFor;
    }
    if (this.description != other.description) {
      changes["Description"] = other.description;
    }
    if (this.webSite != other.webSite) {
      changes["WebSite"] = other.webSite;
    }
    return changes;
  }
}
