import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:plansy_flutter_app/components/fields/input/build_address_text_form_field.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/components/buttons/basic/default_button.dart';
import 'package:plansy_flutter_app/components/fields/input/build_num_of_hours_per_day_text_form_field_for_create.dart';
import 'package:plansy_flutter_app/components/fields/input/build_quality_or_amount_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_starting_hour_text_form_field_for_create.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/trip.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

class CreateTripScreen2 extends StatefulWidget {
  final BuildContext context;
  final String title;
  final String country;
  final String state;
  final String city;
  final String firstDate;
  final String lastDate;

  const CreateTripScreen2({
    this.context,
    this.title,
    this.country,
    this.state,
    this.city,
    this.firstDate,
    this.lastDate,
  });

  @override
  _CreateTripScreen2State createState() => _CreateTripScreen2State();
}

class _CreateTripScreen2State extends State<CreateTripScreen2> {
  final _formKey = GlobalKey<FormState>();

  TimeOfDay startingHour = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay numOfHoursPerDay = TimeOfDay(hour: 0, minute: 0);
  String qualityOrAmount = "";
  String startingAddress = "";
  Coordinates latLngLocation;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
              child: buildPage2Content(),
            ),
          ),
        ),
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
        titleText: '',
        iconsColor: Colors.black);
  }

  Column buildPage2Content() {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.02),
        buildCreateTripForm(),
        buildCreateTripButton(),
        SizedBox(height: getProportionateScreenHeight(15)),
      ],
    );
  }

  Form buildCreateTripForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          BuildAddressTextFormField(
            onSaved: (newValue) => startingAddress = newValue,
            setLatLngLocation: (newValue) => setState(() => latLngLocation = newValue),
            setAddress: (newValue) => setState(() => startingAddress = newValue),
            isEnabled: true,
            labelText: "* Starting address",
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildStartingHourFormFieldForCreate(
            onSaved: (newValue) => startingHour = TimeOfDayExtension.timeFromStr(newValue),
            context: context,
            setStartingHour: (newValue) => setState(() => startingHour = newValue),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildNumOfHoursPerDayTextFormFieldForCreate(
            onSaved: (newValue) => numOfHoursPerDay = TimeOfDayExtension.timeFromStr(newValue),
            context: context,
            setNumOfHoursPerDay: (newValue) {
              setState(() {
                numOfHoursPerDay = newValue;
              });
            },
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildQualityOrAmountField(
            setQualityOrAmount: (newValue) => setState(() => qualityOrAmount = newValue),
            isEnabled: true,
          ),
          SizedBox(height: getProportionateScreenHeight(40)),
        ],
      ),
    );
  }

  DefaultButton buildCreateTripButton() {
    return DefaultButton(
      text: "Create trip",
      press: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          createTrip();
        }
      },
      textColor: Colors.black,
    );
  }

  void createTrip() {
    Trip newTrip = Trip(
      title: widget.title,
      country: widget.country,
      state: widget.state,
      city: widget.city,
      lastDate: widget.lastDate,
      firstDate: widget.firstDate,
      startingAddress: startingAddress,
      startingHour: startingHour,
      qualityOrAmount: qualityOrAmount,
      numOfHoursPerDay: numOfHoursPerDay,
      latLngLocation: latLngLocation,
    );
    User user = Provider.of<Data>(context, listen: false).user;
    Provider.of<Data>(context, listen: false).addTripAndUpdateTheFireBase(widget.context, newTrip, user.email);
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
