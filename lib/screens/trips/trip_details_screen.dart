import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:plansy_flutter_app/components/fields/input/build_address_text_form_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_city_text_form_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_country_text_form_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_first_date_text_form_field_for_details.dart';
import 'package:plansy_flutter_app/components/fields/input/build_last_date_text_form_field_for_details.dart';
import 'package:plansy_flutter_app/components/fields/input/build_num_of_hours_per_day_text_form_field_for_details.dart';
import 'package:plansy_flutter_app/components/fields/input/build_quality_or_amount_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_starting_hour_text_form_field_for_details.dart';
import 'package:plansy_flutter_app/components/fields/input/build_state_text_form_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_country_state_city_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_title_text_form_field.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/trip.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

class TripDetailsScreen extends StatefulWidget {
  @override
  _TripDetailsScreenState createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final MaskTextInputFormatter formatter = MaskTextInputFormatter(mask: "##/##/####");
  List<String> errors = [];

  bool isEnabled = false;
  Trip trip;
  String title = "";
  String country = "";
  DefaultCountry defaultCountry;
  String state = "";
  String city = "";
  String firstDate = "";
  String lastDate = "";
  DateTime date;
  TimeOfDay numOfHoursPerDay = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay startingHour = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay hour;
  String qualityOrAmount = "";
  String startingAddress = "";
  Coordinates latLngLocation;

  TextEditingController _countryController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();

  bool isStateChanged = false;
  bool isCityChanged = false;

  @override
  void initState() {
    super.initState();
    initVars();
  }

  void initVars() {
    int tripIndex = Provider.of<Data>(context, listen: false).tripIndex;
    trip = Provider.of<Data>(context, listen: false).trips[tripIndex];
    defaultCountry = findDefaultCountry(country);
    _countryController.text = trip.country;
    _stateController.text = trip.state;
    _cityController.text = trip.city;
  }

  DefaultCountry findDefaultCountry(String country) {
    for (DefaultCountry i in DefaultCountry.values) {
      if (country.contains(i.toString().substring("DefaultCountry.".length))) {
        return i;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
              child: buildTripDetailsContent(),
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() => isEnabled ? buildSaveAppBar() : buildEditAppBar();

  AppBar buildSaveAppBar() {
    return myAppBar(
      context: context,
      isArrowBack: true,
      isNotification: true,
      isEdit: false,
      isSave: true,
      isTabBar: false,
      isShare: false,
      onPressedSave: onPressedSave,
      titleText: "Trip details",
      iconsColor: Colors.black,
    );
  }

  void onPressedSave() {
    isCityChanged = false;
    isStateChanged = false;
    // do not delete this!
    if (isSomethingWrong()) {}
    if (_formKey.currentState.validate() && !isSomethingWrong()) {
      _formKey.currentState.save();
      setState(() => isEnabled = false);

      updateTrip();

      if (state == null) {
        _stateController.text = "";
      }
      if (city == null) {
        _cityController.text = "";
      }
    }
  }

  void updateTrip() {
    Trip updatedTrip = Trip(
      title: title,
      country: country,
      state: state,
      city: city,
      firstDate: firstDate,
      lastDate: lastDate,
      numOfHoursPerDay: numOfHoursPerDay,
      startingAddress: startingAddress,
      startingHour: startingHour,
      qualityOrAmount: qualityOrAmount,
      latLngLocation: latLngLocation,
    );
    Provider.of<Data>(context, listen: false).updateTrip(updatedTrip);
  }

  bool isSomethingWrong() {
    if (country.isEmpty && !errors.contains(kCountryNullError)) {
      setState(() {
        errors.add(kCountryNullError);
      });
      return true;
    }
    if (country.isNotEmpty && errors.contains(kCountryNullError)) {
      setState(() {
        errors.remove(kCountryNullError);
      });
    }
    return false;
  }

  AppBar buildEditAppBar() {
    return myAppBar(
      context: context,
      isArrowBack: true,
      isNotification: true,
      isEdit: true,
      isSave: false,
      isTabBar: false,
      isShare: false,
      onPressedEdit: onPressedEdit,
      titleText: "Trip details",
      iconsColor: Colors.black,
    );
  }

  void onPressedEdit() => setState(() => isEnabled = true);

  Column buildTripDetailsContent() {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.02),
        buildTitle(),
        SizedBox(height: SizeConfig.screenHeight * 0.07),
        buildTripDetailsForm(),
      ],
    );
  }

  Text buildTitle() {
    return Text(
      "Here are the details of your trip:",
      style: k28BlackStyle,
      textAlign: TextAlign.center,
    );
  }

  Form buildTripDetailsForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildTitleTextFormField(
            initialValue: trip.title,
            isEnabled: isEnabled,
            onSaved: (newValue) => title = newValue,
            isDetails: true,
          ),
          isEnabled ? buildEnabledCountryStateCity() : buildUnEnabledCountryStateCity(),
          BuildFirstDateTextFormFieldForDetails(
            onSaved: (newValue) => firstDate = newValue,
            context: context,
            setFirstDate: (newValue) => setState(() => firstDate = newValue),
            isEnabled: isEnabled,
            initialValue: trip.firstDate,
            lastDate: lastDate,
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildLastDateTextFormFieldForDetails(
            onSaved: (newValue) => lastDate = newValue,
            context: context,
            setLastDate: (newValue) => setState(() => lastDate = newValue),
            isEnabled: isEnabled,
            initialValue: trip.lastDate,
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildAddressTextFormField(
            onSaved: (newValue) => startingAddress = newValue,
            setLatLngLocation: (newValue) => setState(() => latLngLocation = newValue),
            setAddress: (newValue) => setState(() => startingAddress = newValue),
            isEnabled: isEnabled,
            labelText: "Starting address",
            initialValue: trip.startingAddress,
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildStartingHourFormFieldForDetails(
            onSaved: (newValue) => startingHour = TimeOfDayExtension.timeFromStr(newValue),
            context: context,
            setStartingHour: (newValue) => setState(() => startingHour = newValue),
            isEnabled: isEnabled,
            initialValue: TimeOfDayExtension(trip.startingHour).str(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildNumOfHoursPerDayTextFormFieldForDetails(
            onSaved: (newValue) => numOfHoursPerDay = TimeOfDayExtension.timeFromStr(newValue),
            context: context,
            setNumOfHoursPerDay: (newValue) => setState(() => numOfHoursPerDay = newValue),
            isEnabled: isEnabled,
            initialValue: TimeOfDayExtension(trip.numOfHoursPerDay).str(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildQualityOrAmountField(
            setQualityOrAmount: (newValue) => setState(() => qualityOrAmount = newValue),
            isEnabled: isEnabled,
          ),
          SizedBox(height: getProportionateScreenHeight(40)),
        ],
      ),
    );
  }

  Column buildEnabledCountryStateCity() {
    return Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(20)),
        Row(
          children: [
            Text("\t" * 2 + "* Country, state and city", style: k12BlackStyle),
          ],
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        buildCountryStateCityField(
            defaultCountry: defaultCountry,
            setCountry: (value) => setState(() {
                  country = value;
                  _countryController.text = country;
                  defaultCountry = findDefaultCountry(country);
                }),
            setState: (value) => setState(() {
                  isStateChanged = true;
                  state = value;
                  _stateController.text = state;
                }),
            setCity: (value) => setState(() {
                  isCityChanged = true;
                  city = value;
                  _cityController.text = city;
                })),
        SizedBox(height: getProportionateScreenHeight(20)),
      ],
    );
  }

  Column buildUnEnabledCountryStateCity() {
    return Column(
      children: [
        SizedBox(height: getProportionateScreenHeight(10)),
        buildCountryTextFormField(
            isEnabled: isEnabled,
            controller: _countryController,
            onSaved: (newValue) => country = newValue),
        SizedBox(height: getProportionateScreenHeight(10)),
        buildStateTextFormField(
            isEnabled: isEnabled,
            controller: _stateController,
            onSaved: (newValue) => state = newValue),
        SizedBox(height: getProportionateScreenHeight(10)),
        buildCityTextFormField(
            isEnabled: isEnabled,
            controller: _cityController,
            onSaved: (newValue) => city = newValue),
        SizedBox(height: getProportionateScreenHeight(10)),
      ],
    );
  }
}
