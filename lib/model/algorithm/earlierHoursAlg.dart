import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:plansy_flutter_app/model/attraction.dart';


List<ScheduledAttraction> planTripByEarlierHours(
    TimeOfDay startTime, TimeOfDay endOfDayTime, Coordinates location, List<Attraction> cart) {
  if (cart.isEmpty) {
    print("ERROR - ARRAY OF ACTIVITIES IS EMPTY. CAN'T PLAN A TRIP");
    return null;
  }

  Map<List<ScheduledAttraction>, int> bestTrips = {};

  List<ScheduledAttraction> validFirstAttractions =
  findValidFirstAttractions(startTime, endOfDayTime, location, cart);
  for (ScheduledAttraction sAttraction in validFirstAttractions) {
    List<ScheduledAttraction> l = [sAttraction];
    cart.remove(sAttraction.attraction);
    List<ScheduledAttraction> newTrip = returnTrip(
        List<ScheduledAttraction>.from(l),
        List<Attraction>.from(cart),
        sAttraction.endTime, endOfDayTime);
    bestTrips[newTrip] = calculateTripScore(newTrip);
    cart.add(sAttraction.attraction);
  }

  if (bestTrips.isEmpty) {
    return [];
  }
  return returnBestTrip(bestTrips);
}

List<ScheduledAttraction> returnTrip(
    List<ScheduledAttraction> prev, List<Attraction> next, TimeOfDay now, TimeOfDay endOfDayTime) {
  if (next.isEmpty) {
    return prev;
  }
  Attraction current = prev[prev.length - 1].attraction;
  List<ScheduledAttraction> validNextAttraction =
  findValidAttractions(now, endOfDayTime, current, next);
  if (validNextAttraction.isEmpty) {
    return prev;
  }
  TimeOfDay earlyEnd;
  TimeOfDay startOfBest;
  Attraction best;
  bool isFirst = true;
  for (ScheduledAttraction attr in validNextAttraction) {
    if (isFirst) {
      earlyEnd = attr.endTime;
      startOfBest = attr.startTime;
      best = attr.attraction;
      isFirst = false;
    }
    if (earlyEnd >= attr.endTime) {
      earlyEnd = attr.endTime;
      startOfBest = attr.startTime;
      best = attr.attraction;
    }
  }
  prev.add(ScheduledAttraction(attraction: best, startTime: startOfBest, endTime: earlyEnd));
  next.remove(best);
  return returnTrip(prev, next, earlyEnd, endOfDayTime);
}