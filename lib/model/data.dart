import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/activity.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/my_notification.dart';
import 'package:plansy_flutter_app/model/request.dart';
import 'dart:collection';
import 'package:plansy_flutter_app/model/task.dart';
import 'package:plansy_flutter_app/model/trip.dart';
import 'FireBase/FireBaseSingelton.dart';

class Data extends ChangeNotifier {
  // bottom navigation bar
  bool isInHomeScreen = false;
  bool isInBrowseScreen = false;
  bool isInCartScreen = false;
  bool isInWishlistScreen = false;

  User _currentUser;

  void setUser(User user) => _currentUser = user;

  User get user => _currentUser;

  // to-do list
  List<String> _todoListIds = [];

  void addTodoListId(String id){
    _todoListIds.insert(_todoListIds.length, id);
  }

  List<String> get todoListIds => _todoListIds;

  List<List<Task>> _tasks = [];

  void createTasksList(int size){
    for (int i = 0; i < size; i++){
      _tasks.add([]);
    }
  }

  UnmodifiableListView<Task> getTasks(int tripIndex) {
    return UnmodifiableListView(_tasks[tripIndex]);
  }

  void setTasksForOneTrip(List<Task> newList, int tripIdx) {
    _tasks[tripIdx] = newList;
  }

  int getTaskCount(int tripIdx) {
    return _tasks[tripIdx].length;
  }

  void addTask(int tripIdx, String newTaskTitle) {
    final task = Task(name: newTaskTitle);
    _tasks[tripIdx].add(task);
    Map<String, String> mapTasks = tasksToMap(_tasks[tripIdx]);
    FireBaseSingleton().updateTodoList(_todoListIds[tripIdx], mapTasks);
    notifyListeners();
  }

  void markLineOnTask(Task task, int tripIdx) {
    task.toggleDone();
    Map<String, String> mapTasks = tasksToMap(_tasks[tripIdx]);
    FireBaseSingleton().updateTodoList(_todoListIds[tripIdx], mapTasks);
    notifyListeners();
  }

  void deleteTask(int tripIdx, Task task) {
    _tasks[tripIdx].remove(task);
    Map<String, String> mapTasks = tasksToMap(_tasks[tripIdx]);
    FireBaseSingleton().updateTodoList(_todoListIds[tripIdx], mapTasks);
    notifyListeners();
  }

  Map<String, String> tasksToMap(List<Task> tasks){
    Map<String, String> ret = {};
    for(Task task in tasks){
      ret[task.name] = task.isDone ? "done" : "not done";
    }
    return ret;
  }

  //************************************************************************

  // attractions list
  List<Attraction> _attractions = [];
    // Attraction(
    //   status: 0,
    //   name: "London Eye",
    //   imageSrc:
    //       "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/London_Eye_-_TQ04_26.jpg/220px-London_Eye_-_TQ04_26.jpg",
    //   category: "Observation, Park",
    //   address: "Riverside Building, County Hall, London SE1 7PB, United Kingdom",
    //   country: "England",
    //   description: "bla bla bla bla bla bla bla bla bla bla bla bla",
    //   openingTime: TimeOfDay(hour: 7, minute: 0),
    //   closingTime: TimeOfDay(hour: 16, minute: 0),
    //   webSite: 'www.londoneye.com',
    //   pricing: 'Adult: 1.0 EUR\nChild: 2.0 EUR\nStudent: 3.0 EUR\nDisabled: 4.0 EUR\n',
    //   isNeedToBuyTickets: 'Yes',
    //   suitableFor: 'Adults',
    //   recommendations:
    //       'Yael: wow, so beautiful.\n----------\nNarkis: I really enjoyed my time there',
    //   numOfReviews: '521',
    //   rating: '4.5',
    //   suitableSeason: 'Winter, Summer',
    //   duration: TimeOfDay(hour: 1, minute: 0),
    //   priority: 0,
    // ),
    // Attraction(
    //   status: 0,
    //   name: "Tower Bridge",
    //   imageSrc: "https://cdn.getyourguide.com/img/location/5b8e2640b4d58.jpeg/88.jpg",
    //   category: "Bridge",
    //   address: "Tower Bridge Rd, London SE1 2UP, United Kingdom",
    //   country: "England",
    //   description:
    //       "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla",
    //   openingTime: TimeOfDay(hour: 7, minute: 0),
    //   closingTime: TimeOfDay(hour: 16, minute: 0),
    //   webSite: 'www.londontowerbridge.com',
    //   pricing: 'Adult: 1.0 ALL\nChild: 2.0 ALL\nStudent: 3.0 ALL\nDisabled: 4.0 ALL\n',
    //   isNeedToBuyTickets: 'No',
    //   suitableFor: 'Children, Couples',
    //   recommendations: '',
    //   numOfReviews: '0',
    //   rating: '0',
    //   suitableSeason: 'Summer',
    //   duration: TimeOfDay(hour: 1, minute: 0),
    //   priority: 0,
    // ),
    // Attraction(
    //   status: 0,
    //   name: "Tower of London",
    //   imageSrc: "https://cdn.getyourguide.com/img/location/5ca348c3482ea.jpeg/88.jpg",
    //   category: "Historical site",
    //   address: "London EC3N 4AB, United Kingdom",
    //   country: "England",
    //   description: "bla bla bla bla bla bla bla bla bla bla bla bla",
    //   openingTime: TimeOfDay(hour: 7, minute: 0),
    //   closingTime: TimeOfDay(hour: 16, minute: 0),
    //   webSite: 'www.londontowerof.com',
    //   pricing: 'Adult: 1.0 AOA\nChild: 2.0 AOA\nStudent: 3.0 AOA\nDisabled: 4.0 AOA\n',
    //   isNeedToBuyTickets: 'Yes',
    //   suitableFor: 'Children, Couples',
    //   recommendations:
    //       'Yael: wow, so beautiful.\n----------\nNarkis: I really enjoyed my time there',
    //   numOfReviews: '600',
    //   rating: '5',
    //   suitableSeason: 'Summer',
    //   duration: TimeOfDay(hour: 1, minute: 0),
    //   priority: 0,
    // ),
    // Attraction(
    //   status: 0,
    //   name: "National Gallery",
    //   imageSrc:
    //       "https://cdn.londonandpartners.com/asset/national-gallery_the-national-gallery-trafalgar-square-image-courtesy-of-the-national-gallery_6f4aadb5504ea5d216bd00c8e6214995.jpg",
    //   category: "Museum",
    //   address: "Trafalgar Square, London WC2N 5DN, United Kingdom",
    //   country: "England",
    //   description: "bla bla bla bla bla bla bla bla bla bla bla bla",
    //   openingTime: TimeOfDay(hour: 7, minute: 0),
    //   closingTime: TimeOfDay(hour: 16, minute: 0),
    //   webSite: 'www.londonnationalgalery.com',
    //   pricing: 'Adult: 1.0 AOA\nChild: 2.0 AOA\nStudent: 3.0 AOA\nDisabled: 4.0 AOA\n',
    //   isNeedToBuyTickets: 'Yes',
    //   suitableFor: 'Children, Couples',
    //   recommendations:
    //       'Yael: wow, so beautiful.\n----------\nNarkis: I really enjoyed my time there',
    //   numOfReviews: '521',
    //   rating: '4.5',
    //   suitableSeason: 'Autumn',
    //   duration: TimeOfDay(hour: 1, minute: 0),
    //   priority: 0,
    // ),
    // Attraction(
    //   status: 0,
    //   name: "Sky Garden‬",
    //   imageSrc:
    //       "https://skygarden.london/wp-content/uploads/2020/01/Rhubarb-at-Sky-Garden-Web-Sized80-e1579531588784.jpg",
    //   category: "Observation",
    //   address: "1 SKY GARDEN WALK, London EC3M 8AF, UK",
    //   country: "England",
    //   description: "bla bla bla bla bla bla bla bla bla bla bla bla",
    //   openingTime: TimeOfDay(hour: 7, minute: 0),
    //   closingTime: TimeOfDay(hour: 16, minute: 0),
    //   webSite: 'www.londonskygarden.com',
    //   pricing: 'Adult: 1.0 AOA\nChild: 2.0 AOA\nStudent: 3.0 AOA\nDisabled: 4.0 AOA\n',
    //   isNeedToBuyTickets: 'Yes',
    //   suitableFor: 'Children, Couples',
    //   recommendations:
    //       'Yael: wow, so beautiful.\n----------\nNarkis: I really enjoyed my time there',
    //   numOfReviews: '2348',
    //   rating: '5',
    //   suitableSeason: 'Autumn',
    //   duration: TimeOfDay(hour: 1, minute: 0),
    //   priority: 0,
    // ),
    // Attraction(
    //   status: 0,
    //   name: "Hyde Park",
    //   imageSrc:
    //       "https://upload.wikimedia.org/wikipedia/commons/thumb/8/86/Broad_Walk_in_Hyde_Park%2C_by_Park_Lane_-_geograph.org.uk_-_788977.jpg/220px-Broad_Walk_in_Hyde_Park%2C_by_Park_Lane_-_geograph.org.uk_-_788977.jpg",
    //   category: "Park",
    //   address: "Hyde Park, London, UK",
    //   country: "England",
    //   description: "bla bla bla bla bla bla bla bla bla bla bla bla",
    //   openingTime: TimeOfDay(hour: 7, minute: 0),
    //   closingTime: TimeOfDay(hour: 16, minute: 0),
    //   webSite: 'www.londonhydepark.com',
    //   pricing: 'Adult: 1.0 AOA\nChild: 2.0 AOA\nStudent: 3.0 AOA\nDisabled: 4.0 AOA\n',
    //   isNeedToBuyTickets: 'Yes',
    //   suitableFor: 'Children, Couples',
    //   recommendations:
    //       'Yael: wow, so beautiful.\n----------\nNarkis: I really enjoyed my time there',
    //   numOfReviews: '202',
    //   rating: '4.5',
    //   suitableSeason: 'Autumn',
    //   duration: TimeOfDay(hour: 1, minute: 0),
    //   priority: 0,
    // ),
    // Attraction(
    //   status: 0,
    //   name: "Eiffel Tower",
    //   imageSrc: "https://www.hedonistit.com/wp-content/uploads/2019/08/paris-travel-guide-88.jpg",
    //   category: "Observation",
    //   address: "Champ de Mars, 5 Av. Anatole France, 75007 Paris, France",
    //   country: "France",
    //   description: "bla bla bla bla bla bla bla bla bla bla bla bla",
    //   openingTime: TimeOfDay(hour: 7, minute: 0),
    //   closingTime: TimeOfDay(hour: 16, minute: 0),
    //   webSite: 'www.franceeiffel.com',
    //   pricing: 'Adult: 1.0 AOA\nChild: 2.0 AOA\nStudent: 3.0 AOA\nDisabled: 4.0 AOA\n',
    //   isNeedToBuyTickets: 'Yes',
    //   suitableFor: 'Children, Couples',
    //   recommendations:
    //       'Yael: wow, so beautiful.\n----------\nNarkis: I really enjoyed my time there',
    //   numOfReviews: '521',
    //   rating: '4.5',
    //   suitableSeason: 'Autumn',
    //   duration: TimeOfDay(hour: 1, minute: 0),
    //   priority: 0,
    // ),
  // ];

  void setID() {
    for (int i = 0; i < _attractions.length; i++) {
      _attractions[i].setID(i.toString());
    }
  }

  List<Attraction> get attractions => _attractions;

  void setAttractions(List<Attraction> newAttractions) => _attractions = newAttractions;

  int get attractionsCount {
    return _attractions.length;
  }

  Attraction getAttractionByID(String id) {
    for (int i = 0; i < _attractions.length; i++) {
      if (_attractions[i].getID() == id) {
        return _attractions[i];
      }
    }
    return null;
  }

  int findIndexOfAttraction(String attractionName) {
    for (int i = 0; i < attractions.length; i++) {
      if (attractions[i].name == attractionName) {
        return i;
      }
    }
    return -1;
  }

  void deleteAttraction(Attraction attraction) {
    _attractions.remove(attraction);
    notifyListeners();
  }

  void addAttraction(Attraction newAttraction) {
    _attractions.add(newAttraction);
    notifyListeners();
  }

  void addAttractionToFireBase(Attraction attraction){
    attraction.setStatus(0);
    FireBaseSingleton().addAttraction(attraction);
  }

  void deleteAttractionFromFireBase(Attraction attraction){
    FireBaseSingleton().removeAttractionFromFireBase(attraction.getID());
  }

  void ApproveUpdateAttractionInFireBase(Request request, Attraction original) {
    Map<String, dynamic> changes = original.checkForUpdates(request.updatedAttraction);
    if (changes.isNotEmpty) {
      FireBaseSingleton().changeAttraction(request.originalAttractionIdInFireBase, changes);
    }
  }

  void updateAttraction(Attraction attraction, Map<String, dynamic> changes) {
    if (changes.isNotEmpty) {
      FireBaseSingleton().changeAttraction(attraction.getID(), changes);
    }
  }

  //************************************************************************

  // trips list
  List<Trip> _trips = [];
  /*
    Trip(
        title: "My trip to London",
        country: 'England',
        city: 'London',
        firstDate: '01/10/2021',
        lastDate: '01/14/2021',
        state: '',
        qualityOrAmount: 'quality',
        numOfHoursPerDay: TimeOfDay(hour: 2, minute: 0),
        startingAddress: 'startingLocation',
        startingHour: TimeOfDay(hour: 7, minute: 0),
        latLngLocation: Coordinates(51.5031864,-0.11951919999999999),
        isNew: true),
    Trip(
        title: "My trip to Paris",
        country: 'France',
        city: 'Paris',
        firstDate: '01/10/2021',
        lastDate: '01/15/2021',
        state: '',
        qualityOrAmount: 'amount',
        numOfHoursPerDay: TimeOfDay(hour: 7, minute: 0),
        startingAddress: 'startingLocation',
        startingHour: TimeOfDay(hour: 5, minute: 0),
        isNew: false),
    Trip(
      title: "My trip to Israel",
      country: 'Israel',
      city: 'Jerusalem',
      firstDate: '01/10/2021',
      lastDate: '01/16/2021',
      state: '',
      qualityOrAmount: 'amount',
      numOfHoursPerDay: TimeOfDay(hour: 7, minute: 0),
      startingAddress: 'startingLocation',
      startingHour: TimeOfDay(hour: 5, minute: 0),
      isNew: false,
    ),
  ];*/

  int _tripIndex;

  List<Trip> get trips => _trips;

  void setTripIndex(int tripIndex) => _tripIndex = tripIndex;

  int get tripIndex => _tripIndex;

  bool isHomeEditEnabled = false;

  int getTripBackgroundImageNum(int tripID) {
    return tripID % 9;
  }

  int get tripsCount {
    return trips.length;
  }

  void deleteTrip(Trip trip, BuildContext context) {
    FireBaseSingleton().deleteTrip(trip.getID().toString(), context);
    trips.remove(trip);
    notifyListeners();
  }

  void deleteTripWithoutUpdateFireBase(Trip trip){
    trips.remove(trip);
    notifyListeners();
  }

  void addTripAndUpdateTheFireBase(BuildContext context, Trip newTrip, String email){
    FireBaseSingleton().uploadNewTrip(context, newTrip, email, _trips);
  }

  void addTripWithoutUpdateTheFireBase(Trip newTrip){
    trips.add(newTrip);
    notifyListeners();
  }

  void updateTrip(int index, Trip updatedTrip) {
    Map<String, String> changes = _trips[index].createMapChanges(updatedTrip);
    FireBaseSingleton().updateTrip(_trips[index].getID().toString(), changes);

    deleteTripWithoutUpdateFireBase(trips[index]);
    trips.insert(index, updatedTrip);
  }
  //************************************************************************

  // Requests list
  // status: 0 - exist, 1 - new, 2 - updated
  List<Request> _requests = [];

  /*[
    Attraction(
      status: 2,
      name: "London Eye",
      imageSrc:
          "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/London_Eye_-_TQ04_26.jpg/220px-London_Eye_-_TQ04_26.jpg",
      category: "Observationl",
      location: "location",
      country: "England",
      city: "London",
      description: "bla bla bla bla bla bla bla bla bla bla bla bla",
      openingTime: TimeOfDay(hour: 7, minute: 0),
      closingTime: TimeOfDay(hour: 16, minute: 0),
      rushHours: '14:00-15:00',
      webSite: 'www.londoneye.com',
      pricing: '20',
      isNeedToBuyTickets: 'Yes',
      suitableFor: 'children, couples',
      recommendations:
          'Yael: wow, so beautiful.\n----------\nNarkis: I really enjoyed my time there',
      numOfReviews: '521',
      rating: '4.5',
      suitableSeason: 'all',
      duration: TimeOfDay(hour: 1, minute: 0),
    ),
    Attraction(
      status: 0,
      name: "Tower Bridge",
      imageSrc: "https://cdn.getyourguide.com/img/location/5b8e2640b4d58.jpeg/88.jpg",
      category: "Bridges",
      location: "location",
      country: "England",
      city: "London",
      description: "bla bla bla bla bla bla bla bla bla bla bla bla",
      openingTime: TimeOfDay(hour: 7, minute: 0),
      closingTime: TimeOfDay(hour: 16, minute: 0),
      rushHours: '14:00-15:00',
      webSite: 'www.londontowerbridge.com',
      pricing: '20',
      isNeedToBuyTickets: 'No',
      suitableFor: 'children, couples',
      recommendations:
          'Yael: wow, so beautiful.\n----------\nNarkis: I really enjoyed my time there',
      numOfReviews: '20',
      rating: '3.5',
      suitableSeason: 'all',
      duration: TimeOfDay(hour: 1, minute: 0),
    ),
    Attraction(
      status: 0,
      name: "Tower of London",
      imageSrc: "https://cdn.getyourguide.com/img/location/5ca348c3482ea.jpeg/88.jpg",
      category: "Historical sites",
      location: "location",
      country: "England",
      city: "London",
      description: "bla bla bla bla bla bla bla bla bla bla bla bla",
      openingTime: TimeOfDay(hour: 7, minute: 0),
      closingTime: TimeOfDay(hour: 16, minute: 0),
      rushHours: '14:00-15:00',
      webSite: 'www.londontowerof.com',
      pricing: '20',
      isNeedToBuyTickets: 'Yes',
      suitableFor: 'children, couples',
      recommendations:
          'Yael: wow, so beautiful.\n----------\nNarkis: I really enjoyed my time there',
      numOfReviews: '600',
      rating: '5',
      suitableSeason: 'all',
      duration: TimeOfDay(hour: 1, minute: 0),
    ),
  ];*/

  List<Request> get requests => _requests;

  bool isRequestsEmpty = false;

  void checkIfRequestsIsEmpty() {
    if (requestsCount == 0) {
      isRequestsEmpty = true;
    } else {
      isRequestsEmpty = false;
    }
  }

  int get requestsCount {
    return _requests.length;
  }

  void deleteRequest(Request request) {
    FireBaseSingleton().removeAttractionFromFireBase(request.updatedAttraction.getID());
    FireBaseSingleton().deleteRequestFromFireBase(request.getId());
    _requests.remove(request);
    if (requestsCount == 0) {
      isRequestsEmpty = true;
    }
    notifyListeners();
  }

  void addRequestToFireBase(Attraction updatedAttraction, String originalID) async {
    String attrId = await FireBaseSingleton().addAttraction(updatedAttraction);
    Request request = Request(updatedAttraction: updatedAttraction, sender: user.email,
        originalAttractionIdInFireBase: originalID);
    FireBaseSingleton().uploadRequestToFireBase(request);
  }

  void addRequest(Request newRequest) {
    _requests.add(newRequest);
    if (requestsCount != 0) {
      isRequestsEmpty = false;
    }
    notifyListeners();
  }

  Request getRequestFromAttraction(Attraction attraction) {
    for (Request request in _requests) {
      if (request.updatedAttraction == attraction) {
        return request;
      }
    }
  }

//************************************************************************
  // Wish list
  List<Attraction> _wishList = [];

  List<Attraction> get wishlist => _wishList;

  int get wishListCount {
    return _wishList.length;
  }

  bool wishListContains(Attraction attraction) {
    if (_wishList.contains(attraction)) {
      return true;
    }
    return false;
  }

  void deleteAttractionFromWishList(Attraction attraction, BuildContext context, int tripId) {
    _wishList.remove(attraction);
    FireBaseSingleton().deleteFromWishlist(context, tripId.toString(), attraction.getID());
    notifyListeners();
  }

  void addAttractionToWishList(Attraction newAttraction, BuildContext context, int tripId) {
    if (!_wishList.contains(newAttraction)) {
      _wishList.add(newAttraction);
      FireBaseSingleton().addToWishlist(context, tripId.toString(), newAttraction.getID());
      notifyListeners();
    }
  }

  void addToWishListWithoutUpdatingFireBase(Attraction newAttraction) {
    if (!_wishList.contains(newAttraction)) {
      _wishList.add(newAttraction);
      notifyListeners();
    }
  }

  void emptyTheWishlist(String tripId) {
    _wishList.removeRange(0, wishListCount);
    FireBaseSingleton().deleteAllWishlist(tripId);
    notifyListeners();
  }

//************************************************************************
  // cart list
  List<Attraction> _cart = [];

  List<Attraction> get cart => _cart;

  int get cartCount {
    return _cart.length;
  }

  bool cartContains(Attraction attraction) {
    if (_cart.contains(attraction)) {
      return true;
    }
    return false;
  }

  void deleteAttractionFromCart(Attraction attraction, BuildContext context, int tripId) {
    try {
      if (_cart.contains(attraction)) {
        _cart.remove(attraction);
        FireBaseSingleton().deleteFromCart(context, tripId.toString(), attraction.getID());
        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void addToCartWithoutUpdatingTheFireBase(Attraction newAttraction) {
    if (!_cart.contains(newAttraction)) {
      _cart.add(newAttraction);
      notifyListeners();
    }
  }

  void addAttractionToCart(Attraction newAttraction, BuildContext context, int tripId) {
    if (!_cart.contains(newAttraction)) {
      _cart.add(newAttraction);
      FireBaseSingleton().addToCart(context, tripId.toString(), newAttraction.getID());
      notifyListeners();
    }
  }

  void emptyTheCart(String tripId) {
    _cart.removeRange(0, cartCount);
    FireBaseSingleton().deleteAllWishlist(tripId);
    notifyListeners();
  }

  //************************************************************************

  //notifications list
  List<MyNotification> _notifications = [
    // MyNotification(
    //     title:
    //         "The 'London eye' attraction you proposed to add to the database has been approved by the admin",
    //     sender: "user",
    //     now: DateTime.now().toString().substring(0, 16)),
  ];

  List<MyNotification> get notifications => _notifications;

  bool isNotificationsEmpty = true;
  bool isNewNotificationAdded = false;

  void checkIfNotificationsIsEmpty() {
    if (notificationsCount == 0) {
      isNotificationsEmpty = true;
    } else {
      isNotificationsEmpty = false;
    }
  }

  int get notificationsCount {
    return _notifications.length;
  }

  void deleteNotification(MyNotification notification) {
    _notifications.remove(notification);
    if (notificationsCount == 0) {
      isNotificationsEmpty = true;
    }
    notifyListeners();
  }

  void addNotificationToFireBase(MyNotification newNotification) {
    FireBaseSingleton().uploadNotification(newNotification);
  }

  void addNotification(MyNotification newNotification) {
    List<MyNotification> newList = [];
    newList.add(newNotification);
    newList.addAll(notifications);
    _notifications = newList;
    if (notificationsCount != 0) {
      isNotificationsEmpty = false;
    }
    isNewNotificationAdded = true;
    notifyListeners();
  }

  void changeAllNewToOld() {
    for (MyNotification i in notifications) {
      if (i.isNew == true) {
        i.isNew = false;
      }
    }
    isNewNotificationAdded = false;
    notifyListeners();
  }

//************************************************************************

  // route list
  List<List<Activity>> _activities = [];

  /*[
    Activity(
      hour: '16:00',
      attractionName: 'London Eye',
      description: 'bla bla bla bla bla bla bla bla bla bla bla bla',
    ),
    Activity(
      hour: '18:00',
      attractionName: 'Tower Bridge',
      description: 'bla bla bla bla bla bla bla bla bla bla bla bla',
    ),
    Activity(
      hour: '20:00',
      attractionName: 'Tower of London',
      description: 'bla bla bla bla bla bla bla bla bla bla bla bla',
    ),
    Activity(
      hour: '22:00',
      attractionName: 'Hyde Park',
      description: 'bla bla bla bla bla bla bla bla bla bla bla bla',
    ),
  ];*/

  List<List<Activity>> get activities => _activities;

  int getDayActivitiesCount(int dayNum) {
    if (_activities.length > dayNum){
      return _activities[dayNum].length;
    } else {
      return -1;
    }
  }

  // should call once !
  List<List<Activity>> resetAllDaysActivitiesList(int size) {
    _activities = [];
    for (int i = 0; i < size; i++){
      _activities.add([]);
    }
    return _activities;
  }

  void setActivities(List<List<Activity>> activities) => _activities = activities;

  void deleteActivityFromRoute(int numRoute, Activity activity) {
    _activities[numRoute].remove(activity);
    notifyListeners();
  }

  void addActivityToRoute(int numRoute, Activity newActivity) {
    _activities[numRoute].add(newActivity);
    notifyListeners();
  }

  int findIndexOfActivity(int numRoute, String attractionName) {
    for (int i = 0; i < activities[numRoute].length; i++) {
      if (activities[numRoute][i].attractionName == attractionName) {
        return i;
      }
    }
    return -1;
  }

  void changeActivityInSpecificIndex(int numRoute, int index, Activity newActivity) {
    deleteActivityFromRoute(numRoute,activities[numRoute][index]);
    activities[numRoute].insert(index, newActivity);
  }

  Attraction convertActivityToAttraction(String attrName) {
    for (int i = 0; i < attractions.length; i++) {
      if (attractions[i].name == attrName) {
        return attractions[i];
      }
    }
    return null;
  }

  // free time activities
  List<List<Activity>> _freeTimes = [];

  List<List<Activity>> get freeTimes => _freeTimes;

  List<Activity> sortFreeTimes(int dayNum){
    List<Activity> freeTimes = _freeTimes[dayNum];
    freeTimes.sort((Activity a, Activity b){
      TimeOfDay aHour = TimeOfDayExtension.timeFromStr(a.hour);
      TimeOfDay bHour = TimeOfDayExtension.timeFromStr(b.hour);
      return aHour.hour.compareTo(bHour.hour);
    });
    return freeTimes;
  }

  // should call once !
  List<List<Activity>> createFreeTimes(int size) {
    _freeTimes = [];
    for (int i = 0; i < size; i++){
      _freeTimes.add([]);
    }
    return _freeTimes;
  }

  void deleteFreeTime(int numRoute, Activity activity) {
    _freeTimes[numRoute].remove(activity);
    notifyListeners();
  }

  void addFreeTime(int numRoute, Activity newActivity) {
    _freeTimes[numRoute].add(newActivity);
    notifyListeners();
  }

  void resetData(){
    _currentUser = null;
    _tripIndex = 0;
    _attractions = [];
    _cart = [];
    _wishList = [];
    _trips = [];
    _todoListIds = [];
    _tasks = [];
    _freeTimes = [];
    _activities = [];
    _requests = [];
    _notifications = [];
  }
}
