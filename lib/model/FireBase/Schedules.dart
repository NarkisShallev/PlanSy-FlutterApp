import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:plansy_flutter_app/model/FireBase/FireBaseSingelton.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:provider/provider.dart';
import '../activity.dart';
import '../data.dart';

Future<void> loadScheduleDayFromFireBase(FirebaseFirestore firebaseFirestore,
    BuildContext context, String dayId, int dayNumInData) async {
  var doc = await firebaseFirestore.collection('Schedules').doc(dayId).get();
  if (!doc.exists) {
    print('No Schedule Day document!');
  } else {
    List<dynamic> listOfActivities = await doc.data()["activities"];
    for (Map<String, dynamic> activity in listOfActivities) {
      if (activity["duration"] == null){
        continue;
      }
      Activity newActivity;
      if (activity["attractionName"] == "Free time"){
        newActivity = Activity(
            hour: activity["hour"],
            attractionName: activity["attractionName"],
            imageSrc: activity["imageSrc"],
            address: "",
            isNeedToBuyTicketsInAdvance: activity["needTickets"],
            duration: TimeOfDayExtension.timeFromStr(activity["duration"]),
        );
        Provider.of<Data>(context, listen: false).addActivityToRoute(dayNumInData, newActivity);
      } else {
        List<String> latlong = activity["location"].split(",");
        double latitude = double.tryParse(latlong[0]);
        double longitude = double.tryParse(latlong[1]);
        newActivity = Activity(
            hour: activity["hour"],
            attractionName: activity["attractionName"],
            imageSrc: activity["imageSrc"],
            address: activity["address"],
            isNeedToBuyTicketsInAdvance: activity["needTickets"],
            duration: TimeOfDayExtension.timeFromStr(activity["duration"]),
            latLngLocation: Coordinates(latitude, longitude)
        );
        Provider.of<Data>(context, listen: false).addActivityToRoute(dayNumInData, newActivity);
      }
    }
  }
}

Future<bool> loadScheduleFromFireBase(FirebaseFirestore firebaseFirestore, String tripId,
    BuildContext context) async {
  var doc = await firebaseFirestore.collection('Trips').doc(tripId).get();
  var scheduleDays = await doc.data()["schedule"];
  int i=0;
  for (String day in scheduleDays){
    await loadScheduleDayFromFireBase(firebaseFirestore, context, day, i);
    i++;
  }
  return true;
}

Future<List<String>> createScheduleInFireBase(FirebaseFirestore firebaseFirestore, String tripId,
    int numberOfDays) async {
  try {
    List<String> daysId = [];
    for (int i = 0; i < numberOfDays; i++) {
      String id = await FireBaseSingleton().getId("Schedules");
      firebaseFirestore.collection("Schedules").doc(id).set({"activities": []});
      FireBaseSingleton().increaseId("Schedules", id);
      daysId.add(id);
    }
    firebaseFirestore.collection('Trips').doc(tripId).update({"schedule": daysId});
    return daysId;
  } catch (error) {
    print(error.toString());
    return null;
  }
}

Future<bool> deleteScheduleFromFireBase(FirebaseFirestore firebaseFirestore, String tripId,
    List<String> daysIds) async {
  try {
    for (String day in daysIds) {
      firebaseFirestore.collection("Schedules").doc(day).delete();
    }
    firebaseFirestore.collection('Trips').doc(tripId).update({"schedule": []});
    return true;
  } catch (error) {
    print(error.toString());
    return false;
  }
}

Future<bool> uploadScheduleDayToFireBase(FirebaseFirestore firebaseFirestore,
    String id, List<Activity> activitiesSchedule) async {
  try {
    List<Map<String, String>> activities = [];
    for (Activity activity in activitiesSchedule) {
      if (activity.attractionName =="Free time"){
        String location = null;
        if (activity.latLngLocation != null){
          location = "${activity.latLngLocation.latitude.toString()},${activity.latLngLocation.longitude}";
        }
        activities.add({
          "attractionName": activity.attractionName,
          "imageSrc": activity.imageSrc,
          "hour": activity.hour,
          "location": location,
          "needTickets": activity.isNeedToBuyTicketsInAdvance,
          "duration": activity.duration.str(),
        });
      } else {
        activities.add({
          "attractionName": activity.attractionName,
          "imageSrc": activity.imageSrc,
          "hour": activity.hour,
          "location": "${activity.latLngLocation.latitude.toString()},${activity.latLngLocation.longitude}",
          "address": activity.address,
          "needTickets": activity.isNeedToBuyTicketsInAdvance,
          "duration": activity.duration.str(),
          "location": "${activity.latLngLocation.latitude.toString()},${activity.latLngLocation.longitude}"
        });
      }
    }
    firebaseFirestore.collection('Schedules').doc(id).set({
      "activities": activities,
    });

    // 1 if succeeded 0 other.
    return true;
  } on FirebaseException catch (fException) {
    // only executed if error is of type Exception
    print(fException.message);
    return false;
  } catch (error) {
    // executed for errors of all types other than Exception
    print(error.toString());
    return false;
  }
}

Future<void> uploadScheduleToFireBase(FirebaseFirestore firebaseFirestore,
    List<String> scheduleDaysIds, BuildContext context) async{
  List<List<Activity>> activities = Provider.of<Data>(context, listen: false).activities;
  if (activities.length != scheduleDaysIds.length){ print("SCHEDULE ERROR");}
  for (int i = 0; i < scheduleDaysIds.length; i++) {
    uploadScheduleDayToFireBase(firebaseFirestore, scheduleDaysIds[i], activities[i]);
  }
}