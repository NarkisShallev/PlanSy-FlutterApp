import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/components/buttons/basic/default_button.dart';
import 'package:plansy_flutter_app/components/primary_bottom_navigation_bar.dart';
import 'package:plansy_flutter_app/components/fields/search_field.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/trip.dart';
import 'package:plansy_flutter_app/screens/cart/cart_list.dart';
import 'package:plansy_flutter_app/screens/schedule/schedule_screen.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final int tripIndex;

  const CartScreen({this.tripIndex});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Attraction> filteredAttrs;

  void initState() {
    super.initState();
    setState(() => filteredAttrs = Provider.of<Data>(context, listen: false).cart);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: SafeArea(
        child: buildCartScreenContent(context),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return myAppBar(
      context: context,
      isArrowBack: true,
      isNotification: true,
      isEdit: false,
      isSave: false,
      isTabBar: false,
      isShare: false,
      titleText: 'Cart',
      iconsColor: Colors.black,
    );
  }

  PrimaryBottomNavigationBar buildBottomNavigationBar() {
    return PrimaryBottomNavigationBar(
      isHome: false,
      isBrowse: false,
      isWishList: false,
      isCart: true,
      tripIndex: widget.tripIndex,
    );
  }

  Column buildCartScreenContent(BuildContext context) {
    return Column(
      children: [
        buildSearchField(),
        buildCartList(),
        SizedBox(height: getProportionateScreenHeight(15)),
        buildCreateARouteButton(context),
        SizedBox(height: getProportionateScreenHeight(15)),
      ],
    );
  }

  SearchField buildSearchField() {
    return SearchField(
      name: 'Search',
      icon: Icons.search,
      hintText: "Search Here",
      onChanged: (value) => filter(value),
    );
  }

  void filter(value) => setState(() => filteredAttrs = Provider.of<Data>(context, listen: false)
      .cart
      .where((attr) => attr.name.toLowerCase().contains(value.toString().toLowerCase()))
      .toList());

  Expanded buildCartList() => Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
          child: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            child: CartList(filteredAttrs: filteredAttrs),
          ),
        ),
      );

  Padding buildCreateARouteButton(BuildContext context) {
    Trip trip = Provider.of<Data>(context, listen: false).trips[widget.tripIndex];
    List<Attraction> cart = Provider.of<Data>(context, listen: false).cart;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(25)),
      child: DefaultButton(
          text: "Create a route",
          press: () {
            Provider.of<Data>(context, listen: false).resetAllDaysActivitiesList(trip.numDays);
            planTrip(List<Attraction>.from(cart), context, trip);
            moveToScheduleScreen();
          },
          textColor: Colors.black),
    );
  }

  void moveToScheduleScreen() => Navigator.push(context,
      MaterialPageRoute(builder: (context) => ScheduleScreen(tripIndex: widget.tripIndex)));
}
