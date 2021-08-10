import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/screens/trips/create_trip_screen_page_1.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class TripPlusCard extends StatefulWidget {
  @override
  _TripPlusCardState createState() => _TripPlusCardState();
}

class _TripPlusCardState extends State<TripPlusCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(137),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
            child: buildPlusCardContent(context),
          ),
        ),
      ],
    );
  }

  Column buildPlusCardContent(BuildContext context) {
    return Column(
      children: [
        buildPlusIcon(context),
        buildGreyBottomPart(),
      ],
    );
  }

  AspectRatio buildPlusIcon(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: IconButton(
          icon: Icon(Icons.add, size: getProportionateScreenWidth(50)),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (contex) => CreateTripScreenPage1(context: context,))),
        ),
      ),
    );
  }

  Container buildGreyBottomPart() {
    return Container(
      width: getProportionateScreenWidth(137),
      height: getProportionateScreenHeight(70),
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        boxShadow: [kDefaultShadow],
        borderRadius:
            BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
    );
  }
}
