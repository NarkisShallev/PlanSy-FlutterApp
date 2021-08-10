import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/FireBase/FireBaseSingelton.dart';
import 'package:plansy_flutter_app/model/google_maps/google_maps_utilities.dart';
import 'package:provider/provider.dart';
import '../attraction.dart';
import '../data.dart';

Future<void> loadUser(FirebaseFirestore firebaseFirestore, String email, BuildContext context) async {
  //load attractions
  await FireBaseSingleton().loadAttractions(context);

  var userRef = await firebaseFirestore.collection('Users').doc(email).get();
  List<dynamic> notificationIds = userRef.data()["notifications"];
  for (var notificationId in notificationIds) {
    await FireBaseSingleton().loadNotification(context, notificationId.toString());
  }
  List<dynamic> tripIds = userRef.data()["trips"];
  await FireBaseSingleton().loadTrips(context, List<int>.from(tripIds));
}

Future<void> uploadUser(FirebaseFirestore firebaseFirestore, String email, BuildContext context) async {
  //load attractions
  List<Attraction> arr = await FireBaseSingleton().loadAttractions(context);
  Provider.of<Data>(context, listen: false).setAttractions(arr);
  await setAttractionsFirstLocationCoordinatesFromAddresses(arr);

  await firebaseFirestore.collection('Users').doc(email).set({"notifications": [], "trips": []});
}
