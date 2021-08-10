import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:plansy_flutter_app/components/fields/input/build_is_need_to_buy_tickets_in_advance_field.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/components/fields/input/build_closing_time_text_form_field_for_create.dart';
import 'package:plansy_flutter_app/components/fields/input/build_opening_time_text_form_field_for_create.dart';
import 'package:plansy_flutter_app/components/fields/input/build_pricing_field.dart';
import 'package:plansy_flutter_app/screens/attractions/create_attraction_screen_page_3.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class CreateAttractionScreen2 extends StatefulWidget {
  final bool isAdmin;
  final String name;
  final String imageSrc;
  final String category;
  final String address;
  final String country;
  final String description;
  final Coordinates latLngLocation;

  const CreateAttractionScreen2({
    this.isAdmin,
    this.name,
    this.imageSrc,
    this.category,
    this.address,
    this.country,
    this.description,
    this.latLngLocation,
  });

  @override
  _CreateAttractionScreen2State createState() => _CreateAttractionScreen2State();
}

class _CreateAttractionScreen2State extends State<CreateAttractionScreen2> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay openingTime;
  TimeOfDay closingTime;
  String pricing = "";
  String isNeedToBuyTickets = "no";

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
              child: buildPage2Content(context),
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

  Column buildPage2Content(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.02),
        buildCreateAttractionForm(context),
        buildNextButton(context),
      ],
    );
  }

  Form buildCreateAttractionForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          BuildOpeningTimeFormFieldForCreate(
            onSaved: (newValue) => openingTime = TimeOfDayExtension.timeFromStr(newValue),
            context: context,
            setOpeningTime: (newValue) => setState(() => openingTime = newValue),
            closingTime: closingTime,
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildClosingTimeFormFieldForCreate(
              onSaved: (newValue) => closingTime = TimeOfDayExtension.timeFromStr(newValue),
              context: context,
              setClosingTime: (newValue) => setState(() => closingTime = newValue)),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildIsNeedToBuyTicketsField(
            setIsNeedToBuyTickets: (newValue) => setState(() => isNeedToBuyTickets = newValue),
            isUpdate: false,
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildPricingField(
            setPricing: (newValue) => setState(() => pricing = newValue),
            isUpdate: false,
          ),
        ],
      ),
    );
  }

  Row buildNextButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: Text("NEXT >", style: TextStyle(color: kPrimaryColor)),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              moveToNextPage();
            }
          },
        ),
      ],
    );
  }

  void moveToNextPage() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAttractionScreen3(
            isAdmin: widget.isAdmin,
            name: widget.name,
            imageSrc: widget.imageSrc,
            category: widget.category,
            address: widget.address,
            country: widget.country,
            description: widget.description,
            openingTime: openingTime,
            closingTime: closingTime,
            pricing: pricing,
            isNeedToBuyTickets: isNeedToBuyTickets,
            latLngLocation: widget.latLngLocation,
          ),
        ),
      );
}
