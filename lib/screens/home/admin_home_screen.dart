import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/screens/attractions/browse_screen.dart';
import 'package:plansy_flutter_app/screens/home/home_drawer.dart';
import 'package:plansy_flutter_app/screens/requests/admin_requests_screen.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class AdminHomeScreen extends StatefulWidget {
  final _auth = FirebaseAuth.instance;

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  User _loggedInUser;
  String partOfDay = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    partOfDay = convertHourToPartOfDay(DateTime.now().hour);
    load();
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

  void load() async {
    //List<Attraction> arr = await FireBaseSingleton().loadAttractions();
    //Provider.of<Data>(context, listen: false).setAttractions(arr);
    //List<Attraction> l = Provider.of<Data>(context, listen: false).attractions;
    //await setAttractionsFirstLocationCoordinatesFromAddresses(l);
    //FireBaseSingleton().loadRequests(context);
    //FireBaseSingleton().loadCart(context, '1');
    //FireBaseSingleton().loadTodoListFromFireBase(context, '1');
    //FireBaseSingleton().loadTrips(context, ['2']);
    //FireBaseSingleton().loadNotificationFromFireBase(context, '1');
    //FireBaseSingleton().loadScheduleFromFireBase(context, '2');
    //FireBaseSingleton().loadUser("yael11072@gmail.com", context);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
                  child: buildHomeScreenContent(context),
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
      iconsColor: Colors.black);

  Image buildPartOfDayImage() => Image.asset(
        "images/$partOfDay.jpg",
        height: SizeConfig.screenHeight * 0.6,
        fit: BoxFit.cover,
      );

  Column buildHomeScreenContent(BuildContext context) => Column(
      children: [
        buildTitle(),
        SizedBox(height: SizeConfig.screenHeight * 0.5),
        buildSeeExistingAttractionsButton(context),
        SizedBox(height: getProportionateScreenHeight(15)),
        buildRequestsButton(context),
      ],
    );

  Column buildTitle() => Column(
        children: [
          Text('Good $partOfDay!', style: k28BlackStyle),
          Text('What do you want to do today?'),
        ],
      );

  GestureDetector buildSeeExistingAttractionsButton(BuildContext context) => buildOptionButton(
        context: context,
        title: "See existing attractions",
        icon: Icons.now_widgets_outlined,
        onTap: () => moveToBrowseScreen(),
      );

  void moveToBrowseScreen() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BrowseScreen(isAdmin: true),
        ),
      );

  GestureDetector buildRequestsButton(BuildContext context) => buildOptionButton(
        context: context,
        title: "Requests",
        icon: Icons.offline_pin_outlined,
        onTap: () => moveToAdminRequestsScreen(),
      );

  void moveToAdminRequestsScreen() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminRequestsScreen(),
        ),
      );

  GestureDetector buildOptionButton(
      {BuildContext context, String title, IconData icon, Function onTap}) {
    return GestureDetector(
      child: Container(
        height: SizeConfig.screenHeight * 0.1,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor, width: 2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(getProportionateScreenWidth(20)),
          child: buildOptionButtonLabel(title, icon),
        ),
      ),
      onTap: onTap,
    );
  }

  Row buildOptionButtonLabel(String title, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        Spacer(),
        Icon(icon, size: getProportionateScreenWidth(30)),
      ],
    );
  }
}
