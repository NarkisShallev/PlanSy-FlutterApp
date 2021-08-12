import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/FireBase/FireBaseSingelton.dart';
import '../attraction.dart';

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
  await firebaseFirestore.collection('Users').doc(email).set({"notifications": [], "trips": []});
}
