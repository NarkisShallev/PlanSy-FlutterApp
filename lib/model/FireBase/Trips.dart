import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:plansy_flutter_app/model/FireBase/FireBaseSingelton.dart';
import 'package:provider/provider.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import '../data.dart';
import '../trip.dart';

Future<bool> uploadNewTrip(FirebaseFirestore firebaseFirestore,
    BuildContext context, Trip trip, String email, List<Trip> trips) async {
  try {
    // get firebase collection and id field.
    var idDoc = await firebaseFirestore.collection('Trips').doc('id').get();
    var id = idDoc.data()['counter'].toString();

    // add trip to the DB.
    firebaseFirestore.collection('Trips').doc(id).set({
      "title": trip.title,
      "country": trip.country,
      "state": trip.state,
      "city": trip.city,
      "start": trip.firstDate,
      "end": trip.lastDate,
      "numOfHoursPerDay": trip.numOfHoursPerDay.str(),
      "startingAddress": trip.startingAddress,
      "startingLocation": "${trip.latLngLocation.latitude.toString()},${trip.latLngLocation.longitude}",
      "startingHour": trip.startingHour.str(),
      "qualityOrAmount": trip.qualityOrAmount,
      "cart": [],
      "wishlist": [],
    });
    int numDays = calculateDaysOfTrip(DateFormat('MM/dd/yyyy').parse(trip.firstDate),
        DateFormat('MM/dd/yyyy').parse(trip.lastDate));
    await FireBaseSingleton().createSchedule(id, numDays);
    await FireBaseSingleton().createTodoList(id);

    // update the id field - the number of the next attr.
    firebaseFirestore
        .collection('Trips')
        .doc('id')
        .set({'counter': (int.parse(id) + 1).toString()});

    List<int> tripIds = [];
    for (Trip tripI in trips) {
      if (trip.title == tripI.title){
        continue;
      } else {
        tripIds.add(tripI.getID());
      }
    }
    tripIds.add(int.parse(id));

    firebaseFirestore.collection('Users').doc(email).update({"trips": tripIds});

    loadTrips(firebaseFirestore, context, [int.parse(id)], true);
    return true;
  } on FirebaseException catch (fException) {
    // only executed if error is of type Exception
    print(fException.message);
    return false;
  } catch (error) {
    // executed for errors of all types other than Exception
    print("ERROR: ${error.toString()}");
    return false;
  }
}

Future<void> updateTripInFirebase(FirebaseFirestore firebaseFirestore, String id, Map<String, String> changes) async {
  try {
    var tripRef = await firebaseFirestore.collection('Trips').doc(id);
    tripRef.update(changes);
  } catch (error) {
    print(error.toString());
  }
}

void loadTrips(FirebaseFirestore firebaseFirestore, BuildContext context,
    List<int> tripIndexes, bool afterUpload) async {
  // create tasksList
  Provider.of<Data>(context, listen: false).createTasksList(tripIndexes.length);
  var docs = await firebaseFirestore.collection('Trips').get();
  for (int i = 0; i < tripIndexes.length; i++) {
    for (var trip in docs.docs) {
      if (trip.id.compareTo(tripIndexes[i].toString()) == 0) {
        String city = trip.data()["city"];
        String country = trip.data()["country"];
        String state = trip.data()["state"];
        String start = trip.data()["start"];
        String end = trip.data()["end"];
        String title = trip.data()["title"];
        List<dynamic> scheduleIds = trip.data()["schedule"];
        String todolistId = trip.data()["todolist"];
        TimeOfDay numOfHoursPerDay = TimeOfDayExtension.timeFromStr(trip.data()["numOfHoursPerDay"]);
        String startingAddress = trip.data()["startingAddress"];
        TimeOfDay startingHour = TimeOfDayExtension.timeFromStr(trip.data()["startingHour"]);
        String qualityOrAmount = trip.data()["qualityOrAmount"];
        List<String> latlong =  trip.data()["startingLocation"].split(",");
        double latitude = double.tryParse(latlong[0]);
        double longitude = double.tryParse(latlong[1]);
        int numDays = calculateDaysOfTrip(DateFormat('MM/dd/yyyy').parse(start),
            DateFormat('MM/dd/yyyy').parse(end));
        Trip newTrip = Trip(
            title: title,
            country: country,
            state: state,
            city: city,
            firstDate: start,
            lastDate: end,
            numDays: numDays,
            numOfHoursPerDay: numOfHoursPerDay,
            startingAddress: startingAddress,
            startingHour: startingHour,
            qualityOrAmount: qualityOrAmount,
            isNew: false,
            scheduleIds: List<String>.from(scheduleIds),
            todolistId: todolistId,
            latLngLocation: Coordinates(latitude, longitude)
        );
        newTrip.setID(tripIndexes[i]);
        Provider.of<Data>(context, listen: false).addTripWithoutUpdateTheFireBase(newTrip);
        //Provider.of<Data>(context, listen: false).resetAllDaysActivitiesList(newTrip.numDays);
        Provider.of<Data>(context, listen: false).createFreeTimes(newTrip.numDays);
        //FireBaseSingleton().loadSchedule(context, tripIndexes[i].toString());
        //create listlist<task> in size of num trip and then load every todolist.
        if (afterUpload){
          Provider.of<Data>(context, listen: false).addTodoListId(todolistId);
        } else {
          FireBaseSingleton().loadTodoList(context, todolistId, i);
        }
      }
    }
  }
}

int calculateDaysOfTrip(DateTime startDay,DateTime endDay){
  if (startDay.isAfter(endDay)){
    print("ERROR - START DAY IS AFTER END DAY");
    return 0;
  }
  return endDay.day - startDay.day + 1;
}

void deleteTrip(FirebaseFirestore firebaseFirestore, String id, BuildContext context){
  User user = Provider.of<Data>(context, listen: false).user;
  List<Trip> trips = Provider.of<Data>(context, listen: false).trips;
  List<int> tripIds = [];
  for (Trip trip in trips) {
    if (trip.getID().toString().compareTo(id) != 0){
      tripIds.add(trip.getID());
    }
  }
  firebaseFirestore.collection('Users').doc(user.email).update({"trips": tripIds});
  firebaseFirestore.collection('Trips').doc(id).delete();
}