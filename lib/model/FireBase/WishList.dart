import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../attraction.dart';
import '../data.dart';

Future<void> loadWishList(FirebaseFirestore firebaseFirestore, BuildContext context, String tripId) async {
  var trip = await firebaseFirestore.collection('Trips').doc(tripId).get();
  List<dynamic> attrIndexes = trip.data()["wishlist"];
  for (var s in attrIndexes) {
    if (s!=null){
      Attraction a = await Provider.of<Data>(context, listen: false).getAttractionByID(s.toString());
      print(a.name);
      Provider.of<Data>(context, listen: false).addToWishListWithoutUpdatingFireBase(a);
    }
  }
}

Future<void> addToWishList(FirebaseFirestore firebaseFirestore, BuildContext context, String tripId,
    String attractionId) async {
  var trip = await firebaseFirestore.collection('Trips').doc(tripId);
  var wishlist = await trip.get();
  List<dynamic> attrIndexes = wishlist.data()["wishlist"];
  attrIndexes.add(attractionId);
  trip.update({"wishlist": attrIndexes});
}

Future<void> deleteFromWishList(FirebaseFirestore firebaseFirestore, BuildContext context, String tripId,
    String attractionId) async{
  var trip = await firebaseFirestore.collection('Trips').doc(tripId);
  var wishlist = await trip.get();
  List<dynamic> attrIndexes = wishlist.data()["wishlist"];
  attrIndexes.remove(attractionId);
  trip.update({"wishlist": attrIndexes});
}

Future<void> deleteAllWishList(FirebaseFirestore firebaseFirestore, String tripId) async {
  var trip = await firebaseFirestore.collection('Trips').doc(tripId);
  trip.update({"wishlist": []});
}