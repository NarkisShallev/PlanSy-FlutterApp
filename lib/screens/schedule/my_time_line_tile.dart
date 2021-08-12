import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:plansy_flutter_app/components/buttons/remove_circle_button.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/trip.dart';
import 'package:plansy_flutter_app/screens/attractions/attraction_details_screen.dart';
import 'package:plansy_flutter_app/screens/schedule/timeline_indicator.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimeLineTile extends StatefulWidget {
  final TimelineIndicator indicator;
  final String hour;
  final String attractionName;
  final String description;
  final bool isFirst;
  final bool isLast;
  final String imageSrc;
  final String category;
  final String address;
  final String isNeedToBuyTicketsInAdvance;
  final String webSite;
  final TimeOfDay duration;

  const MyTimeLineTile({
    this.indicator,
    this.hour,
    this.attractionName,
    this.description,
    this.isFirst,
    this.isLast,
    this.imageSrc,
    this.category,
    this.address,
    this.isNeedToBuyTicketsInAdvance,
    this.webSite,
    this.duration,
  });

  @override
  _MyTimeLineTileState createState() => _MyTimeLineTileState();
}

class _MyTimeLineTileState extends State<MyTimeLineTile> {
  bool isFirst = false;
  bool isLast = false;

  @override
  void initState() {
    super.initState();
    isFirst = widget.isFirst;
    isLast = widget.isLast;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      children: [
        TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.27,
          beforeLineStyle: LineStyle(color: kPrimaryColor.withOpacity(0.5)),
          indicatorStyle: IndicatorStyle(
            indicatorXY: 0.2,
            drawGap: true,
            width: getProportionateScreenWidth(60),
            height: getProportionateScreenHeight(60),
            indicator: widget.indicator,
          ),
          isFirst: widget.isFirst,
          isLast: widget.isLast,
          startChild: buildHour(),
          endChild: buildMyTimeLineTileContent(),
        ),
        Positioned(
          right: getProportionateScreenWidth(-5),
          top: getProportionateScreenWidth(-5),
          child: buildRemoveCircleButton(),
        ),
      ],
    );
  }

  Center buildHour() => Center(
        child: Container(
          alignment: Alignment(0.0, -0.50),
          child: Text(widget.hour),
        ),
      );

  InkWell buildMyTimeLineTileContent() => InkWell(
        onTap: () {
          int attractionIndex = Provider.of<Data>(context, listen: false)
              .findIndexOfAttraction(widget.attractionName);
          if (widget.attractionName != "Free time") {
            return Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AttractionDetailsScreen(
                  attractionIndex: attractionIndex,
                  isAddToCartButtonVisible: false,
                  isAdmin: false,
                  isApproveOrRejectButtonVisible: false,
                  attraction:
                      Provider.of<Data>(context, listen: false).attractions[attractionIndex],
                  isFavorite: false,
                ),
              ),
            );
          }
        },
        child: Container(
          padding: EdgeInsets.only(
              left: getProportionateScreenWidth(15),
              top: getProportionateScreenWidth(10),
              bottom: getProportionateScreenWidth(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.attractionName),
              buildDurationText(),
              SizedBox(height: getProportionateScreenHeight(4)),
              buildAddressText(),
              buildIsNeedToBuyTicketsText(),
            ],
          ),
        ),
      );

  Text buildDurationText() => Text(
        widget.duration == null
            ? ""
            : "* " + TimeOfDayExtension(widget.duration).str() + " hours stay",
        style: TextStyle(color: Colors.black45),
      );

  Text buildAddressText() => Text(
        widget.address == "" ? "" : "* " + widget.address,
        style: TextStyle(color: Colors.black45),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      );

  Text buildIsNeedToBuyTicketsText() => Text(
        widget.isNeedToBuyTicketsInAdvance == ""
            ? ""
            : "* Is need to buy tickets? " + widget.isNeedToBuyTicketsInAdvance,
        style: TextStyle(color: Colors.black45),
      );

  Row buildRemoveCircleButton() => Row(
        children: [
          RemoveCircleButton(
            removeFromListCallback: () => removeAttractionAndPlanNewTrip(),
          ),
        ],
      );

  void removeAttractionAndPlanNewTrip() {
    //remove attraction from cart
    int tripIndex = Provider.of<Data>(context, listen: false).tripIndex;
    Trip trip = Provider.of<Data>(context, listen: false).trips[tripIndex];
    Attraction attraction = Provider.of<Data>(context, listen: false)
        .convertActivityToAttraction(widget.attractionName);
    Provider.of<Data>(context, listen: false)
        .deleteAttractionFromCart(attraction, context, trip.getID());

    List<Attraction> cart = Provider.of<Data>(context, listen: false).cart;
    Provider.of<Data>(context, listen: false).resetAllDaysActivitiesList(trip.numDays);

    planTrip(List<Attraction>.from(cart), context, trip);
    setState(() {});
  }
}
