import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/model/data.dart';
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
