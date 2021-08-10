import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/FireBase/FireBaseSingelton.dart';
import 'package:provider/provider.dart';
import '../data.dart';
import '../task.dart';

Future<void> loadTodoListFromFireBase(FirebaseFirestore firebaseFirestore, BuildContext context,
    String todoListId, int tripIdx) async {
  var doc = await firebaseFirestore.collection('TodoLists').doc(todoListId).get();
  if (!doc.exists) {
    print('No such document!');
  } else {
    Map<String, dynamic> mapList = doc.data()["list"];
    List<Task> tasks = [];
    mapList.forEach((k, v) =>
        tasks.add(Task(name: k, isDone: v.toString().compareTo("done") == 0 ? true : false)));

    Provider.of<Data>(context, listen: false).setTasksForOneTrip(tasks, tripIdx);
    Provider.of<Data>(context, listen: false).addTodoListId(todoListId);
  }
}

Future<bool> createTodoListInFireBase(FirebaseFirestore firebaseFirestore, String tripId) async {
  try {
    String id = await FireBaseSingleton().getId("TodoLists");
    firebaseFirestore.collection('Trips').doc(tripId).update({"todolist": id});
    firebaseFirestore.collection("TodoLists").doc(id).set({"list": {}});
    FireBaseSingleton().increaseId("TodoLists", id);
    return true;
  } catch (error) {
    print(error.toString());
    return false;
  }
}

Future<bool> updateTodoListInFireBase(FirebaseFirestore firebaseFirestore, String id, Map<String, String> mapList) async {
  try {
    firebaseFirestore.collection('TodoLists').doc(id).set({"list": mapList});
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