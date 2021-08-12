import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/FireBase/TodoList.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/trip.dart';
import '../my_notification.dart';
import '../request.dart';
import 'Notifications.dart';
import 'package:plansy_flutter_app/model/FireBase/Admin.dart' as Admin;
import 'package:plansy_flutter_app/model/FireBase/Trips.dart' as Trips;
import 'package:plansy_flutter_app/model/FireBase/Attractions.dart' as Attractions;
import 'package:plansy_flutter_app/model/FireBase/User_DB.dart' as User_db;
import 'package:plansy_flutter_app/model/FireBase/Carts.dart' as Cart;
import 'package:plansy_flutter_app/model/FireBase/WishList.dart' as Wishlist;
import 'package:plansy_flutter_app/model/FireBase/Schedules.dart' as Schedule;
import 'package:plansy_flutter_app/model/FireBase/Requests.dart' as Requests;

/*
try {

    }catch (error) {
      print("REQUEST LOADING ERROR: ${error.toString()}");
    }
 */

class FireBaseSingleton {
  final _firebaseFirestore = FirebaseFirestore.instance;
  static int counter = 0;

  FireBaseSingleton();

  //create new id in db (don't forget to use increaseID func)
  Future<String> getId(String collection) async {
    // get firebase collection and id field.
    var idDoc = await _firebaseFirestore.collection(collection).doc('id').get();
    return idDoc.data()['counter'].toString();
  }

  void increaseId(String collection, String id) async {
    // update the id field - the number of the next notification.
    await _firebaseFirestore
        .collection(collection)
        .doc('id')
        .set({'counter': (int.parse(id) + 1).toString()});
  }

  List<String> getAttractionsIds(List<Attraction> l) {
    List<String> attractionsInList = [];

    for (Attraction attraction in l) {
      attractionsInList.add(attraction.getID());
    }

    return attractionsInList;
  }

  // attraction
  Future<String> addAttraction(Attraction att) async {
    return await Attractions.addAttractionToFireBase(_firebaseFirestore, att);
  }

  // from the program to the db (at the end of the program)
  void uploadAttractions(List<Attraction> attrs) async {
    try {
      await Attractions.uploadAttractions(_firebaseFirestore, attrs);
    } catch (error) {
      print("ATTRACTIONS UPLOADING ERROR: ${error.toString()}");
    }
  }

// using stream to load the attractions list.
  Future<List<Attraction>> loadAttractions(BuildContext context) async {
    try {
      await Attractions.loadAttractions(_firebaseFirestore, context);
    } catch (error) {
      print("ATTRACTIONS LOADING ERROR: ${error.toString()}");
    }
  }

  Future<Attraction> getAttraction(String id) async {
    try {
      await Attractions.getAttractionFromFireBase(_firebaseFirestore, id);
    } catch (error) {
      print("ATTRACTION LOADING ERROR: ${error.toString()}");
    }
  }

  void changeAttraction(String id, Map<String, dynamic> changes) async {
    try {
      await Attractions.changeAttraction(_firebaseFirestore, id, changes);
    } catch (error) {
      print("ATTRACTION CHANGE ERROR: ${error.toString()}");
    }
  }

  void removeAttractionFromFireBase(String id, BuildContext context) async {
    try {
      await Attractions.removeAttractionFromFireBase(_firebaseFirestore, id, context);
    } catch (error) {
      print("ATTRACTIONS LOADING ERROR: ${error.toString()}");
    }
  }

  // trips
  void uploadNewTrip(BuildContext context, Trip trip,String email, List<Trip> trips) async {
    try {
      await Trips.uploadNewTrip(_firebaseFirestore, context, trip, email, trips);
    } catch(error) {
      print("UPLOAD TRIP ERROR: ${error.toString()}");
    }
  }

  void updateTrip(String id, Map<String, String> changes) async {
    await Trips.updateTripInFirebase(_firebaseFirestore, id, changes);
  }

  Future<void> loadTrips(BuildContext context, List<int> tripIndexes) async {
    try {
      Trips.loadTrips(_firebaseFirestore, context, tripIndexes, false);
    }catch (error) {
      print("TRIPS LOADING ERROR: ${error.toString()}");
    }
  }

  void deleteTrip(String tripId, BuildContext context){
    try {
      Trips.deleteTrip(_firebaseFirestore, tripId, context);
    }catch (error) {
      print("TRIPS DELETE ERROR: ${error.toString()}");
    }
  }

  //user
  Future<void> loadUser(String email, BuildContext context) async {
    try {
      await User_db.loadUser(_firebaseFirestore, email, context);
    } catch (error) {
      print("USER LOADING ERROR: ${error.toString()}");
    }
  }

  Future<bool> checkIfUserExistsInDB(String email) async {
    var userRef = await _firebaseFirestore.collection('Users').doc(email);
    var doc = await userRef.get();

    return doc.exists;
  }

  void uploadUser(String email, BuildContext context) async {
    try {
      await User_db.uploadUser(_firebaseFirestore, email, context);
    } catch (error) {
      print("USER UPLOADING ERROR: ${error.toString()}");
    }
  }

  //admin
  Future<void> loadRequests(BuildContext context) async {
    try {
      await Admin.loadRequests(_firebaseFirestore, context);
    } catch (error) {
      print("REQUEST LOADING ERROR: ${error.toString()}");
    }
  }

  Future<void> loadAdmin(String email, BuildContext context) async {
    try {
      await Admin.loadAdmin(_firebaseFirestore, email, context);
    } catch (error) {
      print("ADMIN LOADING ERROR: ${error.toString()}");
    }
  }

  //cart
  Future<void> loadCart(BuildContext context, String tripId) async {
    try {
      await Cart.loadCart(_firebaseFirestore, context, tripId);
    } catch (error) {
      print("CART LOADING ERROR: ${error.toString()}");
    }
  }

  void addToCart(BuildContext context, String tripId, String attractionId) async {
    try {
      await Cart.addToCart(_firebaseFirestore, context, tripId, attractionId);
    } catch (error) {
      print("CART ADD ERROR: ${error.toString()}");
    }
  }

  void deleteFromCart(BuildContext context, String tripId, String attractionId) async {
    try {
      await Cart.deleteFromCart(_firebaseFirestore, context, tripId, attractionId);
    } catch (error) {
      print("CART DELETE ERROR: ${error.toString()}");
    }
  }

  void deleteAllCart(String tripId) async {
    try {
      await Cart.deleteAllCart(_firebaseFirestore, tripId);
    } catch (error) {
      print("CART DELETE ALL ERROR: ${error.toString()}");
    }
  }


  //wishlist
  Future<void> loadWishlist(BuildContext context, String tripId) async {
    try {
      await Wishlist.loadWishList(_firebaseFirestore, context, tripId);
    } catch (error) {
      print("WishList LOADING ERROR: ${error.toString()}");
    }
  }

  void addToWishlist(BuildContext context, String tripId, String attractionId) async {
    try {
      await Wishlist.addToWishList(_firebaseFirestore, context, tripId, attractionId);
    } catch (error) {
      print("Wishlist ADD ERROR: ${error.toString()}");
    }
  }

  void deleteFromWishlist(BuildContext context, String tripId, String attractionId) async {
    try {
      await Wishlist.deleteFromWishList(_firebaseFirestore, context, tripId, attractionId);
    } catch (error) {
      print("Wishlist DELETE ERROR: ${error.toString()}");
    }
  }

  void deleteAllWishlist(String tripId) async {
    try {
      await Wishlist.deleteAllWishList(_firebaseFirestore, tripId);
    } catch (error) {
      print("Wishlist DELETE ALL ERROR: ${error.toString()}");
    }
  }

  // notifications
  Future<void> loadNotification(BuildContext context, String notificationId) async {
    try {
      await loadNotificationFromFireBase(_firebaseFirestore, context, notificationId);
    } catch (error) {
      print("NOTIFICATION LOADING ERROR: ${error.toString()}");
    }
  }

  Future<bool> uploadNotification(MyNotification notification) async {
    try {
      await uploadNotificationToFireBase(_firebaseFirestore, notification);
    } catch (error) {
      print("NOTIFICATION UPLOADING ERROR: ${error.toString()}");
    }
  }

  void updateNotificationStatus(List<String> notificationsIds) async {
    try {
      await updateNotificationStatusInFireBase(_firebaseFirestore, notificationsIds);
    } catch (error) {
      print("NOTIFICATION UPDATE ERROR: ${error.toString()}");
    }
  }

  // todolists
  Future<void> loadTodoList(BuildContext context, String todoListId, int tripId) async {
    try {
      await loadTodoListFromFireBase(_firebaseFirestore, context, todoListId, tripId);
    } catch (error) {
      print("TODOLIST LOADING ERROR: ${error.toString()}");
    }
  }

  Future<bool> createTodoList(String tripId) async {
    await createTodoListInFireBase(_firebaseFirestore, tripId);
  }

  Future<bool> updateTodoList(String id, Map<String, String> mapList) async {
    await updateTodoListInFireBase(_firebaseFirestore, id, mapList);
  }


  // schedule
  Future<void> loadSchedule(BuildContext context, String tripId) async {
    try {
      await Schedule.loadScheduleFromFireBase(_firebaseFirestore, tripId, context);
    } catch (error) {
      print("SCHEDULE LOADING ERROR: ${error.toString()}");
    }
  }

  Future<List<String>> createSchedule(String tripId, int numOfDays) async {
    try{
      return await Schedule.createScheduleInFireBase(_firebaseFirestore, tripId, numOfDays);
    } catch (error) {
      print("SCHEDULE CREATION ERROR: ${error.toString()}");
    }
  }

  void uploadSchedule(List<String> daysIds, BuildContext context) async {
    try {
      await Schedule.uploadScheduleToFireBase(_firebaseFirestore, daysIds, context);
    } catch (error) {
      print("SCHEDULE UPLOADING ERROR: ${error.toString()}");
    }
  }

  //Request
  Future<void> loadRequest(BuildContext context, String requestId) async {
    try {
      await Requests.loadRequestFromFireBase(_firebaseFirestore, context, requestId);
    } catch (error) {
      print("REQUEST LOADING ERROR: ${error.toString()}");
    }
  }

  Future<bool> uploadRequestToFireBase(Request request) async {
    try {
      await Requests.uploadRequestToFireBase(_firebaseFirestore, request);
    } catch (error) {
      print("REQUEST UPLOADING ERROR: ${error.toString()}");
    }
  }

  void deleteRequestFromFireBase(String id) async{
    try {
      await Requests.deleteRequestFromFireBase(_firebaseFirestore, id);
    } catch (error) {
      print("REQUEST DELETE ERROR: ${error.toString()}");
    }
  }
}
