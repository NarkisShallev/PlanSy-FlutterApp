import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plansy_flutter_app/components/fields/input/build_duration_text_form_field_for_create.dart';
import 'package:plansy_flutter_app/components/fields/input/build_starting_hour_text_form_field_for_create.dart';
import 'package:plansy_flutter_app/model/activity.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/trip.dart';
import 'package:plansy_flutter_app/screens/schedule/schedule_screen.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

Future<void> showAddFreeTimeDialog(
    BuildContext context, int tripIndex, TabController tabController) async {
  TimeOfDay startingHour = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay duration = TimeOfDay(hour: 0, minute: 0);

  Trip trip = Provider.of<Data>(context, listen: false).trips[tripIndex];
  DateTime firstTripDate = trip.getFirstDateInDateTimeFormat();
  DateTime currentTripDate = firstTripDate.add(Duration(days: tabController.index));

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: buildTitle(currentTripDate),
        content: SingleChildScrollView(
          child: Column(
            children: [
              BuildStartingHourFormFieldForCreate(
                  onSaved: (newValue) => startingHour = TimeOfDayExtension.timeFromStr(newValue),
                  context: context,
                  setStartingHour: (newValue) => startingHour = newValue),
              SizedBox(height: getProportionateScreenHeight(10)),
              BuildDurationTextFormFieldForCreate(
                onSaved: (newValue) => duration = TimeOfDayExtension.timeFromStr(newValue),
                setDuration: (newValue) => duration = newValue,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Add', style: TextStyle(color: kPrimaryColor)),
            onPressed: () {
              Activity newActivity = Activity(
                hour: TimeOfDayExtension(startingHour).str(),
                attractionName: "Free time",
                imageSrc: "free_time.png",
                duration: duration,
                address: "",
                isNeedToBuyTicketsInAdvance: "",
              );
              Provider.of<Data>(context, listen: false).resetAllDaysActivitiesList(trip.numDays);
              //Provider.of<Data>(context, listen: false).addActivityToRoute(tabController.index, newActivity);
              Provider.of<Data>(context, listen: false)
                  .addFreeTime(tabController.index, newActivity);
              List<Attraction> cart = Provider.of<Data>(context, listen: false).cart;
              planTrip(List<Attraction>.from(cart), context, trip);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              moveToScheduleScreen(context, tripIndex);
            },
          ),
        ],
      );
    },
  );
}

void moveToScheduleScreen(BuildContext context, int tripIndex) => Navigator.push(
    context, MaterialPageRoute(builder: (context) => ScheduleScreen(tripIndex: tripIndex)));

Text buildTitle(DateTime currentTripDate) => Text(
    'Pick start hour and duration for free time in ${DateFormat('MM/dd/yyyy').format(currentTripDate)}:',
    textAlign: TextAlign.center);
