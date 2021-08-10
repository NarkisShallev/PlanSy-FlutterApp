import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/google_maps/google_maps_utilities.dart';
import 'package:plansy_flutter_app/screens/home/home_drawer.dart';
import 'package:plansy_flutter_app/screens/trips/trip_list.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final _auth = FirebaseAuth.instance;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User _loggedInUser;
  String partOfDay = '';
  bool isEditEnabled;

  @mustCallSuper
  void initState() {
    super.initState();
    getCurrentUser();
    partOfDay = convertHourToPartOfDay(DateTime.now().hour);
    //waitToLatLng();
    load();
  }

  void waitToLatLng() async {
    List<Attraction> l = Provider.of<Data>(context, listen: false).attractions;
    await setAttractionsFirstLocationCoordinatesFromAddresses(l);
  }

  void load() async {
    //List<Attraction> arr = await FireBaseSingleton().loadAttractions();
    //Provider.of<Data>(context, listen: false).setAttractions(arr);
    //List<Attraction> l = Provider.of<Data>(context, listen: false).attractions;
    //FireBaseSingleton().loadRequests(context);
    //FireBaseSingleton().loadCart(context, '1');
    //FireBaseSingleton().loadTodoListFromFireBase(context, '1');
    //FireBaseSingleton().loadTrips(context, ['2']);
    //FireBaseSingleton().loadNotificationFromFireBase(context, '1');
    //FireBaseSingleton().loadScheduleFromFireBase(context, '2');
    //FireBaseSingleton().loadUser("yael11072@gmail.com", context);
    //await setAttractionsFirstLocationCoordinatesFromAddresses(l);
  }

  void getCurrentUser() {
    try {
      final user = widget._auth.currentUser;
      if (user != null) {
        _loggedInUser = user;
      }
    } catch (e) {
      print(e.code);
    }
  }

  String convertHourToPartOfDay(int hour) {
    if ((hour >= 5) & (hour < 12)) {
      return 'morning';
    } else if ((hour >= 12) & (hour < 17)) {
      return 'afternoon';
    } else if ((hour >= 17) & (hour < 21)) {
      return 'evening';
    } else {
      return 'night';
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    deactivate();
    isEditEnabled = Provider.of<Data>(context, listen: false).isHomeEditEnabled;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context),
      drawer: HomeDrawer(auth: widget._auth, email: _loggedInUser.email),
      body: Stack(
        children: [
          buildPartOfDayImage(),
          SingleChildScrollView(
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                  child: buildHomeScreenContent(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //todo: remove requests that rejected
  // @mustCallSuper
  // void deactivate() {
  //   super.deactivate();
  //   List<Attraction> data = Provider.of<Data>(context, listen: false).attractions;
  //   FireBaseSingleton().uploadAttractions(data);
  //   //FireBaseSingleton().uploadTrips(context);;
  //   //FireBaseSingleton().uploadNotificationToFireBase(notification);
  //   //List<Activity> activities = Provider.of<Data>(context, listen: false).activities;
  //   //if(activities.isNotEmpty){
  //   //  FireBaseSingleton().uploadScheduleToFireBase('2', activities);
  //   //}
  // }

  AppBar buildAppBar(BuildContext context) => myAppBar(
        context: context,
        isArrowBack: false,
        isNotification: true,
        isEdit: false,
        isSave: false,
        isTabBar: false,
        isShare: false,
        titleText: '',
        iconsColor: Colors.black,
      );

  Image buildPartOfDayImage() => Image.asset(
        "images/$partOfDay.jpg",
        height: SizeConfig.screenHeight * 0.6,
        fit: BoxFit.cover,
      );

  Column buildHomeScreenContent() => Column(
        children: [
          buildTitle(),
          SizedBox(height: SizeConfig.screenHeight * 0.4),
          buildTripsSectionTitle(),
          Container(
              height: SizeConfig.screenHeight * 0.3, width: double.infinity, child: TripList()),
        ],
      );

  Column buildTitle() => Column(
        children: [
          Text('Good $partOfDay!', style: k28BlackStyle),
          Text('What do you want to do today?'),
        ],
      );

  Row buildTripsSectionTitle() => Row(
        children: [
          buildYourTripsSubTitle(),
          Spacer(),
          isEditEnabled
              ? IconButton(onPressed: () => onPressedSave(), icon: Icon(Icons.save_outlined))
              : IconButton(onPressed: () => onPressedEdit(), icon: Icon(Icons.edit)),
        ],
      );

  Text buildYourTripsSubTitle() => Text(
        "Your trips:",
        style: TextStyle(fontSize: getProportionateScreenWidth(16), fontWeight: FontWeight.bold),
      );

  void onPressedSave() =>
      setState(() => Provider.of<Data>(context, listen: false).isHomeEditEnabled = false);

  void onPressedEdit() => setState(() {
        Provider.of<Data>(context, listen: false).isHomeEditEnabled = true;
      });
}
