import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:plansy_flutter_app/model/FireBase/FireBaseSingelton.dart';
import 'package:plansy_flutter_app/model/algorithm/priorityAlg.dart';
import 'package:plansy_flutter_app/model/algorithm/earlierHoursAlg.dart';
import 'package:plansy_flutter_app/model/activity.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/trip.dart';
import 'package:plansy_flutter_app/model/google_maps/google_maps_utilities.dart';
import 'package:provider/provider.dart';

extension TimeOfDayExtension on TimeOfDay {
  TimeOfDay add({int hour = 0, int minute = 0}) {
    int isAnotherHourNeeded = 0;
    if (this.minute + minute > TimeOfDay.minutesPerHour) {
      isAnotherHourNeeded = 1;
    }
    return this.replacing(
        hour: (this.hour + hour + isAnotherHourNeeded) % TimeOfDay.hoursPerDay,
        minute: (this.minute + minute) % TimeOfDay.minutesPerHour);
  }

  bool operator >=(TimeOfDay other) {
    if (this.hour > other.hour) {
      return true;
    } else if (this.hour < other.hour) {
      return false;
    }
    // hour=hour
    if (this.minute >= other.minute) {
      return true;
    }
    // this.minute<other.minute
    return false;
  }

  String str() {
    String _addLeadingZeroIfNeeded(int value) {
      if (value < 10) return '0$value';
      return value.toString();
    }

    final String hourLabel = _addLeadingZeroIfNeeded(hour);
    final String minuteLabel = _addLeadingZeroIfNeeded(minute);

    return '$hourLabel:$minuteLabel';
  }

  static TimeOfDay timeFromStr(String s) {
    return TimeOfDay(
        hour: int.parse(s.split(":")[0]), minute: int.parse(s.split(":")[1]));
  }
}

class ScheduledAttraction {
  Attraction attraction;
  TimeOfDay startTime;
  TimeOfDay endTime;

  ScheduledAttraction({@required this.attraction,@required this.startTime,@required this.endTime});
}

List<ScheduledAttraction> findValidFirstAttractions(
    TimeOfDay startTime,TimeOfDay endOfDayTime, Coordinates location, List<Attraction> nextAttractions) {
  Attraction demo = Attraction(
      status: 0,
      name: "name",
      imageSrc: "imageSrc",
      category: "category",
      address: "location",
      country: "country",
      description: "description",
      openingTime: TimeOfDay(hour: startTime.hour, minute: startTime.minute),
      // TODO: if there is a limit on the travel time - or endTime of travel
      closingTime: TimeOfDay(hour: 0, minute: 0),
      webSite: "webSite",
      pricing: "payment",
      isNeedToBuyTickets: "isNeedToBuyTicketsInAdvance",
      suitableFor: "suitableFor",
      recommendations: "recommendations",
      numOfReviews: "numOfReviews",
      rating: "rating",
      suitableSeason: "suitableWeather",
      duration: TimeOfDay(hour: 0, minute: 0));
  demo.setLatLngLocation(location);
  return findValidAttractions(startTime, endOfDayTime, demo, nextAttractions);
}

List<ScheduledAttraction> returnBestTrip(
    Map<List<ScheduledAttraction>, int> map) {
  int max = 0;
  List<ScheduledAttraction> bestTrip;
  map.forEach((key, value) {
    if (value > max) {
      max = value;
      bestTrip = key;
    }
  });
  return bestTrip;
}

ScheduledAttraction findScheduledAttraction(List<ScheduledAttraction> l, Attraction attraction){
  for (ScheduledAttraction s in l){
    if (s.attraction == attraction){
      return s;
    }
  }
  return null;
}

List<ScheduledAttraction> findValidAttractions(
    TimeOfDay timeNow, TimeOfDay endOfDayTime, Attraction current, List<Attraction> nextAttractions) {
  List<ScheduledAttraction> valid = [];

  for (Attraction attr in nextAttractions) {
    TimeOfDay timeToTravel = calculateDistance(current, attr);
    if (timeToTravel == null) {
      continue;
    }
    TimeOfDay newTime = timeNow
        .add(hour: timeToTravel.hour, minute: timeToTravel.minute)
        .add(hour: attr.duration.hour, minute: attr.duration.minute);
    if (timeNow >= TimeOfDay(hour: 12, minute: 0) &&
        TimeOfDay(hour: 12, minute: 0) >= newTime) {
      continue;
    }
    if (newTime >= endOfDayTime){
      if (!(endOfDayTime >= newTime)){
        continue;
      }
    }
    if (attr.closingTime >= newTime) {
      // if opening time + duration > new time
      if (attr.openingTime
          .add(hour: attr.duration.hour, minute: attr.duration.minute) >=
          newTime) {
        ScheduledAttraction s = ScheduledAttraction(attraction: attr,
            startTime: timeNow.add(hour: timeToTravel.hour, minute: timeToTravel.minute),
            endTime: attr.openingTime.add(hour: attr.duration.hour, minute: attr.duration.minute));
        valid.add(s);
      } else {
        ScheduledAttraction s = ScheduledAttraction(attraction: attr,
            startTime: timeNow.add(hour: timeToTravel.hour, minute: timeToTravel.minute),
            endTime: newTime);
        valid.add(s);
      }
    }
  }
  return valid;
}

int calculateTripScore(List<ScheduledAttraction> trip) {
  return trip.length;
}

TimeOfDay calculateDistance(Attraction a, Attraction b) {
  double distance = getDistanceInKm(a.latLngLocation, b.latLngLocation);
  return kmToTime(distance);
}

void createActivities(int dayNum, List<ScheduledAttraction> plannedTrip, BuildContext context, Activity freeTime) {
  for (ScheduledAttraction attr in plannedTrip) {
    Activity newActivity = Activity(
      hour: attr.startTime.str(),
      attractionName: attr.attraction.name,
      imageSrc: attr.attraction.imageSrc,
      duration: attr.attraction.duration,
      address: attr.attraction.address,
      latLngLocation: attr.attraction.latLngLocation,
      isNeedToBuyTicketsInAdvance: attr.attraction.isNeedToBuyTickets,
    );
    Provider.of<Data>(context, listen: false).addActivityToRoute(dayNum, newActivity);
  }
  if (freeTime!=null){
    Provider.of<Data>(context, listen: false).addActivityToRoute(dayNum, freeTime);
  }
}

bool attractionInReadyTrip(Attraction attraction,List<ScheduledAttraction> readyTrip){
  for (ScheduledAttraction scheduledAttraction in readyTrip){
    if (scheduledAttraction.attraction==attraction){
      return true;
    }
  }
  return false;
}

List<Attraction> returnLeftAttractions(List<Attraction> cart, List<ScheduledAttraction> readyTrip){
  if (readyTrip.isEmpty){
    return cart;
  }
  List<Attraction> left = [];

  for(Attraction attraction in cart){
    if (!attractionInReadyTrip(attraction, readyTrip)){
      left.add(attraction);
    }
  }

  return left;
}

Map<TimeOfDay, TimeOfDay> returnPartsOfDays(BuildContext context, int day, Trip trip,TimeOfDay endTimeOfDay){
  List<Activity> activities = Provider.of<Data>(context, listen: false).sortFreeTimes(day);
  Map<TimeOfDay, TimeOfDay> partsOfDay = {};
  TimeOfDay start = trip.startingHour;
  TimeOfDay end = trip.startingHour.add(hour: trip.numOfHoursPerDay.hour, minute: trip.numOfHoursPerDay.minute);

  for (Activity activity in activities){
      end = TimeOfDayExtension.timeFromStr(activity.hour);
      partsOfDay[start] = end;
      start = end.add(hour: activity.duration.hour, minute: activity.duration.minute);
  }
  partsOfDay[start] = endTimeOfDay;

  return partsOfDay;
}

Activity findFreeTimeActivity(TimeOfDay startFreeTime, BuildContext context, int day){
  List<Activity> activities = Provider.of<Data>(context, listen: false).freeTimes[day];

  for (Activity activity in activities){
    if (activity.hour.compareTo(startFreeTime.str()) == 0){
      return activity;
    }
  }
}


void planTrip(List<Attraction> cart, BuildContext context, Trip trip) async{
  TimeOfDay endTimeOfDay = trip.startingHour.add(hour: trip.numOfHoursPerDay.hour, minute: trip.numOfHoursPerDay.minute);

  for (int day = 0; day < trip.numDays; day++) {
    Map<TimeOfDay, TimeOfDay> partsOfDays = returnPartsOfDays(context, day, trip, endTimeOfDay);
    if (cart.length > 0) {
        partsOfDays.forEach((start, end) {
          if (cart.isEmpty){
            return;
          }
          List<ScheduledAttraction> plannedTrip = [];
          if (trip.qualityOrAmount=="quality") {
            if (plannedTrip.isEmpty) {
              plannedTrip = planTripByEarlierHours(
                  start, end, trip.latLngLocation, cart);
            } else {
              plannedTrip = planTripByEarlierHours(
                  start, end,
                  plannedTrip[plannedTrip.length - 1].attraction.latLngLocation,
                  cart);
            }
          } else {
            if (plannedTrip.isEmpty) {
              plannedTrip = planTripByPriority(
                  start, end, trip.latLngLocation, cart);
            } else {
              plannedTrip = planTripByPriority(
                  start, end,
                  plannedTrip[plannedTrip.length - 1].attraction.latLngLocation,
                  cart);
            }
          }
          cart = returnLeftAttractions(cart, plannedTrip);

          //create activities (if for add a free time activity)
          if(end != endTimeOfDay){
            createActivities(day, plannedTrip, context, findFreeTimeActivity(end, context, day));
          } else {
            createActivities(day, plannedTrip, context, null);
          }
        });
    }
  }

  FireBaseSingleton().uploadSchedule(trip.scheduleIds, context);
}