import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/components/buttons/Floating_action_button/create_attraction_floating_action_button.dart';
import 'package:plansy_flutter_app/components/primary_bottom_navigation_bar.dart';
import 'package:plansy_flutter_app/components/fields/search_field.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/google_maps/google_maps_utilities.dart';
import 'package:plansy_flutter_app/model/trip.dart';
import 'package:plansy_flutter_app/screens/attractions/admin_attraction_list.dart';
import 'package:plansy_flutter_app/screens/attractions/attraction_list.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

class BrowseScreen extends StatefulWidget {
  final int tripIndex;
  final bool isAdmin;

  const BrowseScreen({this.tripIndex, @required this.isAdmin});

  @override
  _BrowseScreenState createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  List<Attraction> filteredAttrs;
  Trip trip;
  String tripCountryInGoogleMaps;

  void initState() {
    super.initState();
    trip = Provider.of<Data>(context, listen: false).trips[widget.tripIndex];
    // setState(() => filteredAttrs = Provider.of<Data>(context, listen: false).attractions);
    filterByTripCountry();
  }

  void filterByTripCountry() async {
    await convertToGoogleMapsCountry();
    setState(() => filteredAttrs = Provider.of<Data>(context, listen: false)
        .attractions
        .where((attr) => (attr.country.toLowerCase() == tripCountryInGoogleMaps.toLowerCase()))
        .toList());
  }

  Future<void> convertToGoogleMapsCountry() async =>
      tripCountryInGoogleMaps = await findCountryFromAddress(trip.country);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: Stack(
        children: [
          SafeArea(
            child: buildBrowseContent(),
          ),
          CreateAttractionFloatingActionButton(isAdmin: widget.isAdmin),
        ],
      ),
    );
  }

  Column buildBrowseContent() {
    return Column(
      children: [
        buildSearchField(),
        Expanded(
          child: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            child: widget.isAdmin
                ? AdminAttractionList(filteredAttrs: filteredAttrs)
                : AttractionList(tripIndex: widget.tripIndex, filteredAttrs: filteredAttrs),
          ),
        ),
      ],
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
      titleText: '',
      iconsColor: Colors.black,
    );
  }

  Visibility buildBottomNavigationBar() {
    return Visibility(
      visible: !widget.isAdmin,
      child: PrimaryBottomNavigationBar(
        isHome: false,
        isBrowse: true,
        isWishList: false,
        isCart: false,
        tripIndex: widget.tripIndex,
      ),
    );
  }

  SearchField buildSearchField() {
    return SearchField(
      name: 'Search',
      icon: Icons.search,
      hintText: "Search Here",
      onChanged: ((value) => filterByName(value)),
    );
  }

  void filterByName(value) =>
      setState(() => filteredAttrs = Provider.of<Data>(context, listen: false)
          .attractions
          .where((attr) => attr.name.toLowerCase().contains(value.toString().toLowerCase()))
          .toList());
}
