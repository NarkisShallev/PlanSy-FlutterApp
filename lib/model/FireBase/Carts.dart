import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../attraction.dart';
import '../data.dart';

Future<void> loadCart(FirebaseFirestore firebaseFirestore, BuildContext context, String tripId) async {
  var cart = await firebaseFirestore.collection('Trips').doc(tripId).get();
  List<dynamic> attrIndexes = cart.data()["cart"];
  for (var s in attrIndexes) {
    if (s!=null){
      Attraction a = await Provider.of<Data>(context, listen: false).getAttractionByID(s.toString());
      Provider.of<Data>(context, listen: false).addToCartWithoutUpdatingTheFireBase(a);
    }
  }
}

Future<void> addToCart(FirebaseFirestore firebaseFirestore, BuildContext context, String tripId,
    String attractionId) async {
  var trip = await firebaseFirestore.collection('Trips').doc(tripId);
  var cart = await trip.get();
  List<dynamic> attrIndexes = cart.data()["cart"];
  attrIndexes.add(attractionId);
  trip.update({"cart": attrIndexes});
}

Future<void> deleteFromCart(FirebaseFirestore firebaseFirestore, BuildContext context, String tripId,
    String attractionId) async{
  var trip = await firebaseFirestore.collection('Trips').doc(tripId);
  var cart = await trip.get();
  List<dynamic> attrIndexes = cart.data()["cart"];
  attrIndexes.remove(attractionId);
  trip.update({"cart": attrIndexes});
}

Future<void> deleteAllCart(FirebaseFirestore firebaseFirestore, String tripId) async {
  var trip = await firebaseFirestore.collection('Trips').doc(tripId);
  trip.update({"cart": []});
}