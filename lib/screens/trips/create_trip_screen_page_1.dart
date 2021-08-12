import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/components/buttons/next_button.dart';
import 'package:plansy_flutter_app/components/fields/input/build_first_date_text_form_field_for_create.dart';
import 'package:plansy_flutter_app/components/fields/input/build_country_state_city_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_last_date_text_form_field_for_create.dart';
import 'package:plansy_flutter_app/components/fields/input/build_title_text_form_field.dart';
import 'package:plansy_flutter_app/screens/trips/create_trip_screen_page_2.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class CreateTripScreenPage1 extends StatefulWidget {
  final BuildContext context;

  CreateTripScreenPage1({@required this.context});
  @override
  _CreateTripScreenPage1State createState() => _CreateTripScreenPage1State();
}

class _CreateTripScreenPage1State extends State<CreateTripScreenPage1> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String country = "";
  String state = "";
  String city = "";
  String firstDate = "";
  String lastDate = "";

  List<String> errors = [];

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
              child: buildPage1Content(context),
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
      iconsColor: Colors.black,
    );
  }

  Column buildPage1Content(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.02),
        buildTitle(),
        SizedBox(height: SizeConfig.screenHeight * 0.07),
        buildCreateTripForm(),
        buildNextButton(),
      ],
    );
  }

  Text buildTitle() =>
      Text("Add your trip details:", style: k28BlackStyle, textAlign: TextAlign.center);

  Form buildCreateTripForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildTitleTextFormField(onSaved: (newValue) => title = newValue, isDetails: false),
          SizedBox(height: getProportionateScreenHeight(20)),
          Row(
            children: [
              Text("\t" * 2 + "* Country, state and city", style: k12BlackStyle),
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildCountryStateCityField(
            setCountry: (newValue) => setState(() => country = newValue),
            setState: (newValue) => setState(() => state = newValue),
            setCity: (newValue) => setState(() => city = newValue),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildCountryError(),
          SizedBox(height: getProportionateScreenHeight(20)),
          BuildFirstDateTextFormFieldForCreate(
            onSaved: (newValue) => firstDate = newValue,
            context: context,
            setFirstDate: (newValue) => setState(() => firstDate = newValue),
            lastDate: lastDate,
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildLastDateTextFormFieldForCreate(
            onSaved: (newValue) => lastDate = newValue,
            context: context,
            setLastDate: (newValue) => setState(() => lastDate = newValue),
          ),
        ],
      ),
    );
  }

  Visibility buildCountryError() {
    return Visibility(
      visible: errors.contains(kCountryNullError),
      child: Row(
        children: [
          Text("\t" * 12 + kCountryNullError, style: k11Point5RedStyle),
        ],
      ),
    );
  }

  NextButton buildNextButton() {
    return NextButton(
      onPressed: () {
        // do not delete this!
        if (isSomethingWrong()) {}
        if (_formKey.currentState.validate() && errors.isEmpty) {
          _formKey.currentState.save();
          moveToNextPage();
        }
      },
    );
  }

  bool isSomethingWrong() {
    if (country.isEmpty && !errors.contains(kCountryNullError)) {
      setState(() => errors.add(kCountryNullError));
      return true;
    }
    if (country.isNotEmpty && errors.contains(kCountryNullError)) {
      setState(() => errors.remove(kCountryNullError));
    }
    return false;
  }

  void moveToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTripScreen2(
          context: widget.context,
          title: title,
          country: country,
          state: state,
          city: city,
          firstDate: firstDate,
          lastDate: lastDate,
        ),
      ),
    );
  }
}
