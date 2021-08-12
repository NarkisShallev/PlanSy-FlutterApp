import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data.dart';
import '../my_notification.dart';

Future<void> loadNotificationFromFireBase(FirebaseFirestore firebaseFirestore,
    BuildContext context, String notificationId) async {
  var doc = await firebaseFirestore.collection('Notifications').doc(notificationId).get();
  if (!doc.exists) {
    print('No such document!');
  } else {
    bool dataIsNew;
    if (doc.data()["isNew"] == "false"){
      dataIsNew = false;
    } else {
      dataIsNew = true;
    }
    bool isNew = dataIsNew;
    String now = doc.data()["now"];
    String sender = doc.data()["sender"];
    String title = doc.data()["title"];
    MyNotification newNotification =
    MyNotification(isNew: isNew, now: now, sender: sender, title: title, receiver: null);
    Provider.of<Data>(context, listen: false).addNotification(
        newNotification);
  }
}

Future<bool> uploadNotificationToFireBase(FirebaseFirestore firebaseFirestore,
    MyNotification notification) async {
  try {
    // get firebase collection and id field.
    var idDoc = await firebaseFirestore.collection('Notifications').doc('id').get();
    var id = idDoc.data()['counter'].toString();

    firebaseFirestore.collection('Notifications').doc(id).set({
      "isNew": notification.isNew,
      "sender": notification.sender,
      "now": notification.now,
      "title": notification.title
    });

    // update the id field - the number of the next notification.
    firebaseFirestore
        .collection('Notifications')
        .doc('id')
        .set({'counter': (int.parse(id) + 1).toString()});


    var userDoc = await firebaseFirestore.collection('Users').doc(notification.receiver).get();
    List<dynamic> notifications = userDoc.data()["notifications"];
    List<String> ids = [];
    for (var n in notifications){
      ids.add(n.toString());
    }
    ids.add(id);
    await firebaseFirestore.collection('Users').doc(notification.receiver).update({"notifications": ids});
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

void updateNotificationStatusInFireBase(FirebaseFirestore firebaseFirestore,
    List<String> notificationsIds) async {
  for (String id in notificationsIds){
    await firebaseFirestore.collection("Notifications").doc(id).update({"isNew": "false"});
  }
}