import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plansy_flutter_app/model/FireBase/Attractions.dart' as Attractions;
import '../attraction.dart';
import '../data.dart';
import '../request.dart';
import 'FireBaseSingelton.dart';

Future<void> loadRequests(FirebaseFirestore firebaseFirestore, BuildContext context) async {
  var docs = await firebaseFirestore.collection('Requests').get();
  for (var req in docs.docs) {
    if (req.id.compareTo("id")==0){
      continue;
    }
    Attraction attraction = await Attractions.getAttractionFromFireBase(firebaseFirestore,
        req.data()["updatedAttraction"].toString());
    String sender = req.data()["sender"];
    String originalId = req.data()["originAttrID"];
    Request request = Request(updatedAttraction: attraction, sender: sender,
        originalAttractionIdInFireBase: originalId);
    request.setId(req.id);
    Provider.of<Data>(context, listen: false).addRequest(request);
  }
}

Future<void> loadAdmin(FirebaseFirestore firebaseFirestore, String email, BuildContext context) async {
  //load attractions
  await FireBaseSingleton().loadAttractions(context);

  var adminRef = await firebaseFirestore.collection('Admins').doc(email).get();
  await loadRequests(firebaseFirestore, context);
  List<dynamic> tripIds = adminRef.data()["trips"];
  await FireBaseSingleton().loadTrips(context, List<int>.from(tripIds));
}