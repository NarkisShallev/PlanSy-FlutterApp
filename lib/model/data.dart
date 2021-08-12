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
import 'package:provider/provider.dart';
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

  void addTodoListId(String id) {
    _todoListIds.insert(_todoListIds.length, id);
  }

  List<String> get todoListIds => _todoListIds;

  List<List<Task>> _tasks = [];

  void createTasksList(int size) {
    for (int i = 0; i < size; i++) {
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

  Map<String, String> tasksToMap(List<Task> tasks) {
    Map<String, String> ret = {};
    for (Task task in tasks) {
      ret[task.name] = task.isDone ? "done" : "not done";
    }
    return ret;
  }

  //************************************************************************

  // attractions list
  List<Attraction> _attractions = [];

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
      if (_attractions[i].getID().compareTo(id) == 0) {
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

  void addAttractionToFireBase(Attraction attraction) {
    attraction.setStatus(0);
    FireBaseSingleton().addAttraction(attraction);
  }

  void deleteAttractionFromFireBase(Attraction attraction, BuildContext context) {
    FireBaseSingleton().removeAttractionFromFireBase(attraction.getID(), context);
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

  void deleteTripWithoutUpdateFireBase(Trip trip) {
    trips.remove(trip);
    notifyListeners();
  }

  void addTripAndUpdateTheFireBase(BuildContext context, Trip newTrip, String email) {
    FireBaseSingleton().uploadNewTrip(context, newTrip, email, _trips);
  }

  void addTripWithoutUpdateTheFireBase(Trip newTrip) {
    trips.add(newTrip);
    notifyListeners();
  }

  void updateTrip(Trip updatedTrip) {
    Map<String, String> changes = _trips[tripIndex].createMapChanges(updatedTrip);
    FireBaseSingleton().updateTrip(_trips[tripIndex].getID().toString(), changes);

    deleteTripWithoutUpdateFireBase(trips[tripIndex]);
    trips.insert(tripIndex, updatedTrip);
  }

  //************************************************************************

  // Requests list
  // status: 0 - exist, 1 - new, 2 - updated
  List<Request> _requests = [];

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

  void deleteRequest(Request request, BuildContext context) {
    FireBaseSingleton().removeAttractionFromFireBase(request.updatedAttraction.getID(), context);
    FireBaseSingleton().deleteRequestFromFireBase(request.getId());
    _requests.remove(request);
    if (requestsCount == 0) {
      isRequestsEmpty = true;
    }
    notifyListeners();
  }

  void addRequestToFireBase(Attraction updatedAttraction, String originalID) async {
    String attrId = await FireBaseSingleton().addAttraction(updatedAttraction);
    Request request = Request(
        updatedAttraction: updatedAttraction,
        sender: user.email,
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
  List<MyNotification> _notifications = [];

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
    if(newNotification.isNew == true){
      isNewNotificationAdded = true;
    }
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

  List<String> _notificationsIds = [];

  void setNotificationsIds(List<String> ids){
    _notificationsIds = ids;
  }

  List<String> get notificationsIds => _notificationsIds;

//************************************************************************

  // route list
  List<List<Activity>> _activities = [];

  List<List<Activity>> get activities => _activities;

  int getDayActivitiesCount(int dayNum) {
    if (_activities.length > dayNum) {
      return _activities[dayNum].length;
    } else {
      return -1;
    }
  }

  // should call once !
  List<List<Activity>> resetAllDaysActivitiesList(int size) {
    _activities = [];
    for (int i = 0; i < size; i++) {
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
    deleteActivityFromRoute(numRoute, activities[numRoute][index]);
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

  List<Activity> sortFreeTimes(int dayNum) {
    List<Activity> freeTimes = _freeTimes[dayNum];
    freeTimes.sort((Activity a, Activity b) {
      TimeOfDay aHour = TimeOfDayExtension.timeFromStr(a.hour);
      TimeOfDay bHour = TimeOfDayExtension.timeFromStr(b.hour);
      return aHour.hour.compareTo(bHour.hour);
    });
    return freeTimes;
  }

  // should call once !
  List<List<Activity>> createFreeTimes(int size) {
    _freeTimes = [];
    for (int i = 0; i < size; i++) {
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

  void resetData() {
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
