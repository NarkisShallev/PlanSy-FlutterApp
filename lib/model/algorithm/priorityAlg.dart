import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'algorithm_utilities.dart';

Attraction findBestPreferenceAttraction(List<ScheduledAttraction> validNextAttraction){
  int bestPreference = -1;
  Attraction bestAttr;
  for (ScheduledAttraction sAttraction in validNextAttraction) {
    if (sAttraction.attraction.priority > bestPreference) {
      bestPreference = sAttraction.attraction.priority;
      bestAttr = sAttraction.attraction;
    }
  }
  return bestAttr;
}

List<ScheduledAttraction> removeAttr(Attraction a,
    List<ScheduledAttraction> list){
  List<ScheduledAttraction> ret = [];
  for (ScheduledAttraction s in list){
    if (!(s.attraction.name.compareTo(a.name)==0)){
      ret.add(s);
    }
  }
  return ret;
}

List<ScheduledAttraction> planTripByPriority(
    TimeOfDay startTime,TimeOfDay endOfDayTime, Coordinates location, List<Attraction> cart) {
  if (cart.isEmpty) {
    print("ERROR - ARRAY OF ACTIVITIES IS EMPTY. CAN'T PLAN A TRIP");
    return null;
  }

  List<ScheduledAttraction> validFirstAttractions =
  findValidFirstAttractions(startTime, endOfDayTime, location, cart);
  if (validFirstAttractions.isEmpty){
    return [];
  }

  Attraction bestAttr = findBestPreferenceAttraction(validFirstAttractions);
  List<ScheduledAttraction> copyWithoutBest = removeAttr(bestAttr, validFirstAttractions);
  Attraction secondBestAttr = findBestPreferenceAttraction(copyWithoutBest);

  List<ScheduledAttraction> l = [];
  Attraction chosen;
  Random random = new Random();
  int randomNumber = random.nextInt(100); // from 0 up to 99 included
  if (randomNumber > 20 && secondBestAttr != null) {
    chosen = secondBestAttr;
  } else {
    if (bestAttr != null) {
      chosen = bestAttr;
    }
  }
  ScheduledAttraction chosenSA = findScheduledAttraction(validFirstAttractions, chosen);
  l.add(chosenSA);
  cart.remove(chosen);
  List<ScheduledAttraction> newTrip = returnTrip(
      List<ScheduledAttraction>.from(l),
      endOfDayTime,
      List<Attraction>.from(cart),
      chosenSA.endTime);
  return newTrip;
}


List<ScheduledAttraction> returnTrip(
    List<ScheduledAttraction> prev, TimeOfDay endOfDayTime, List<Attraction> next, TimeOfDay now) {
  if (next.isEmpty) {
    return prev;
  }
  Attraction current = prev[prev.length - 1].attraction;
  List<ScheduledAttraction> validNextAttraction =
  findValidAttractions(now, endOfDayTime, current, next);
  if (validNextAttraction.isEmpty) {
    return prev;
  }
  Attraction bestAttr = findBestPreferenceAttraction(validNextAttraction);
  List<ScheduledAttraction> copyWithoutBest = removeAttr(bestAttr, validNextAttraction);
  Attraction secondBestAttr = findBestPreferenceAttraction(copyWithoutBest);

  Attraction chosen;
  Random random = new Random();
  int randomNumber = random.nextInt(100); // from 0 up to 99 included
  if (randomNumber > 20 && secondBestAttr != null) {
    chosen = secondBestAttr;
  } else {
    if (bestAttr != null) {
      chosen = bestAttr;
    }
  }
  ScheduledAttraction chosenSA = findScheduledAttraction(validNextAttraction, chosen);
  prev.add(chosenSA);
  next.remove(chosen);
  return returnTrip(prev, endOfDayTime, next, chosenSA.endTime);
}
