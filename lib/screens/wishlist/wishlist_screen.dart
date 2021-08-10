import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/components/primary_bottom_navigation_bar.dart';
import 'package:plansy_flutter_app/components/fields/search_field.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/screens/wishlist/wishlist_list.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  List<Attraction> filteredAttrs;

  void initState() {
    super.initState();
    setState(() => filteredAttrs = Provider.of<Data>(context, listen: false).wishlist);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: SafeArea(
        child: buildWishListScreenContent(),
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
        titleText: 'Wish list',
        iconsColor: Colors.black);
  }

  PrimaryBottomNavigationBar buildBottomNavigationBar() {
    return PrimaryBottomNavigationBar(
        isHome: false, isBrowse: false, isWishList: true, isCart: false);
  }

  Column buildWishListScreenContent() {
    return Column(
      children: [
        buildSearchField(),
        buildWishListList(),
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

  void filter(value) => setState(() {
        filteredAttrs = Provider.of<Data>(context, listen: false)
            .wishlist
            .where((attr) => attr.name.toLowerCase().contains(value.toString().toLowerCase()))
            .toList();
      });

  Expanded buildWishListList() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
        child: Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight,
          child: WishListList(filteredAttrs: filteredAttrs),
        ),
      ),
    );
  }
}
