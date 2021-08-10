import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/FireBase/FireBaseSingelton.dart';
import 'package:plansy_flutter_app/model/request.dart';
import 'package:provider/provider.dart';
import '../attraction.dart';
import '../data.dart';

Future<void> loadRequestFromFireBase(FirebaseFirestore firebaseFirestore,
    BuildContext context, String requestId) async {
  var doc = await firebaseFirestore.collection('Requests').doc(requestId).get();
  if (!doc.exists) {
    print('No such document!');
  } else {
    String attractionId = doc.data()["updatedAttraction"];
    Attraction attraction = await FireBaseSingleton().getAttraction(attractionId);
    String sender = doc.data()["sender"];
    String originalId = doc.data()["originAttrID"];
    Request newRequest = Request(updatedAttraction: attraction, sender: sender,
        originalAttractionIdInFireBase: originalId);
    Provider.of<Data>(context, listen: false).addRequest(newRequest);
  }
}

Future<bool> uploadRequestToFireBase(FirebaseFirestore firebaseFirestore,
    Request request) async {
  try {
    // get firebase collection and id field.
    var idDoc = await firebaseFirestore.collection('Requests').doc('id').get();
    var id = idDoc.data()['counter'].toString();

    firebaseFirestore.collection('Requests').doc(id).set({
      "sender": request.sender,
      "updatedAttraction": request.updatedAttraction.getID(),
      "originAttrID": request.originalAttractionIdInFireBase,
    });

    // update the id field - the number of the next notification.
    firebaseFirestore
        .collection('Requests')
        .doc('id')
        .set({'counter': (int.parse(id) + 1).toString()});

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

void deleteRequestFromFireBase(FirebaseFirestore firebaseFirestore, String id) async{
  var idDoc = await firebaseFirestore.collection('Requests').doc(id).delete();
}