import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';

class Trip {
  final String title;
  final String country;
  final String state;
  final String city;
  final String firstDate;
  final String lastDate;
  final int numDays;
  final TimeOfDay numOfHoursPerDay;
  final String startingAddress;
  Coordinates latLngLocation;
  final TimeOfDay startingHour;
  final String qualityOrAmount;
  final bool isNew;
  final List<String> scheduleIds;
  final String todolistId;

  // ID in DB
  int _id;

  Trip({
    @required this.title,
    @required this.country,
    @required this.state,
    @required this.city,
    @required this.firstDate,
    @required this.lastDate,
    @required this.numDays,
    @required this.numOfHoursPerDay,
    @required this.startingAddress,
    @required this.startingHour,
    @required this.qualityOrAmount,
    @required this.latLngLocation,
    @required this.isNew=false,
    @required this.scheduleIds,
    @required this.todolistId
  });

  void setID(int id) {
    _id = id;
  }

  int getID() {
    return _id;
  }

  void setLatlngLocation(Coordinates location){
    this.latLngLocation = location;
  }

  DateTime getFirstDateInDateTimeFormat() {
    return DateFormat('MM/dd/yyyy').parse(firstDate); //don't change to little mm
  }

  DateTime getLastDateInDateTimeFormat() {
    return DateFormat('MM/dd/yyyy').parse(lastDate); //don't change to little mm
  }

  Map<String, String> createMapChanges(Trip updated){
    Map<String, String> changes = {};

    if (this.title != updated.title && updated.title != ""){
      changes["title"] = updated.title;
    }
    if (this.country != updated.country && updated.country != ""){
      changes["country"] = updated.country;
    }
    if (this.state != updated.state && updated.state != ""){
      changes["state"] = updated.state;
    }
    if (this.city != updated.city && updated.city != "" && updated.city != null){
      changes["city"] = updated.city;
    }
    if (this.firstDate != updated.firstDate && updated.firstDate != null){
      changes["start"] = updated.firstDate;
    }
    if (this.lastDate != updated.lastDate && updated.lastDate != null){
      changes["end"] = updated.lastDate;
    }
    if (this.numOfHoursPerDay != updated.numOfHoursPerDay && updated.numOfHoursPerDay != null){
      changes["numOfHoursPerDay"] = TimeOfDayExtension(updated.numOfHoursPerDay).str();
    }
    if (this.startingAddress != updated.startingAddress && updated.startingAddress != null){
      changes["startingAddress"] = updated.startingAddress;
    }
    if (this.latLngLocation != updated.latLngLocation && updated.latLngLocation != null){
      changes["startingLocation"] = "${updated.latLngLocation.latitude.toString()},${updated.latLngLocation.longitude}";
    }
    if (this.startingHour != updated.startingHour && updated.startingHour != null){
      changes["startingHour"] = TimeOfDayExtension(updated.startingHour).str();
    }
    if (this.qualityOrAmount != updated.qualityOrAmount && updated.qualityOrAmount != ""){
      changes["qualityOrAmount"] = updated.qualityOrAmount;
    }
    return changes;
  }
}
