import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/buttons/remove_circle_button.dart';
import 'package:plansy_flutter_app/model/FireBase/FireBaseSingelton.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/trip.dart';
import 'package:plansy_flutter_app/screens/todo-lists/tasks_screen.dart';
import 'package:plansy_flutter_app/screens/schedule/schedule_screen.dart';
import 'package:plansy_flutter_app/screens/trips/trip_details_screen.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

class TripCard extends StatefulWidget {
  final int tripIndex;
  final Function removeFromListCallback;

  const TripCard({this.tripIndex, this.removeFromListCallback});

  @override
  _TripCardState createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(137),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
            child: buildTripCardContent(context),
          ),
        ),
        buildMoreIcon(),
        buildRemoveIcon(context)
      ],
    );
  }

  Column buildTripCardContent(BuildContext context) {
    return Column(
      children: [
        buildTripCardImage(),
        buildDescription(context),
      ],
    );
  }

  AspectRatio buildTripCardImage() {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(getProportionateScreenWidth(20)),
            topRight: Radius.circular(getProportionateScreenWidth(20)),
          ),
          image: DecorationImage(image: AssetImage("images/trip_card.jpg"), fit: BoxFit.cover),
        ),
      ),
    );
  }

  Container buildDescription(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(137),
      height: getProportionateScreenHeight(70),
      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [kDefaultShadow],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(getProportionateScreenWidth(20)),
          bottomRight: Radius.circular(getProportionateScreenWidth(20)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(1)),
        child: buildTripTitle(context),
      ),
    );
  }

  Text buildTripTitle(BuildContext context) {
    return Text(
      "${Provider.of<Data>(context, listen: true).trips[widget.tripIndex].title}",
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: getProportionateScreenWidth(12)),
    );
  }

  Positioned buildMoreIcon() {
    int _value;
    return Positioned(
      left: getProportionateScreenWidth(-90),
      top: getProportionateScreenWidth(-4),
      child: Row(
        children: [
          buildMoreIconDropdownButton(_value),
        ],
      ),
    );
  }

  DropdownButton<int> buildMoreIconDropdownButton(int _value) {
    return DropdownButton(
      icon: Icon(Icons.more),
      style: const TextStyle(color: Colors.black),
      underline: Container(color: Colors.transparent),
      items: [
        buildTripDetailsDropdownMenuItem(),
        buildTODOListDropdownMenuItem(),
        buildScheduleDropdownMenuItem(),
      ],
      onChanged: (value) => setState(() => _value = value),
    );
  }

  DropdownMenuItem<int> buildTripDetailsDropdownMenuItem() {
    return DropdownMenuItem(
      child: TextButton(
        onPressed: () {
          Provider.of<Data>(context, listen: false).setTripIndex(widget.tripIndex);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TripDetailsScreen(),
            ),
          );
        },
        child: Text("Trip's details", style: TextStyle(color: kPrimaryColor)),
      ),
      value: 1,
    );
  }

  DropdownMenuItem<int> buildTODOListDropdownMenuItem() {
    return DropdownMenuItem(
      child: TextButton(
          onPressed: () {
            Provider.of<Data>(context, listen: false).setTripIndex(widget.tripIndex);
            Navigator.push(context, MaterialPageRoute(builder: (context) => TasksScreen()));
          },
          child: Text("TODO List", style: TextStyle(color: kPrimaryColor))),
      value: 2,
    );
  }

  DropdownMenuItem<int> buildScheduleDropdownMenuItem() {
    return DropdownMenuItem(
      child: TextButton(
          onPressed: () async {
            // set trip index and schedule.
            Provider.of<Data>(context, listen: false).setTripIndex(widget.tripIndex);
            Trip trip = Provider.of<Data>(context, listen: false).trips[widget.tripIndex];
            Provider.of<Data>(context, listen: false).resetAllDaysActivitiesList(trip.numDays);
            await FireBaseSingleton().loadSchedule(context, trip.getID().toString());
            Provider.of<Data>(context, listen: false).createFreeTimes(trip.numDays);

            //set cart and wishlist
            await FireBaseSingleton().loadCart(context, trip.getID().toString());
            await FireBaseSingleton().loadWishlist(context, trip.getID().toString());

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScheduleScreen(),
              ),
            );
          },
          child: Text("Schedule", style: TextStyle(color: kPrimaryColor))),
      value: 3,
    );
  }

  Visibility buildRemoveIcon(BuildContext context) {
    return Visibility(
      visible: Provider.of<Data>(context, listen: false).isHomeEditEnabled,
      child: Positioned(
        right: getProportionateScreenWidth(-5),
        top: getProportionateScreenWidth(-10),
        child: Row(
          children: [
            RemoveCircleButton(removeFromListCallback: widget.removeFromListCallback),
          ],
        ),
      ),
    );
  }
}
