import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:plansy_flutter_app/components/dialogs/show_send_to_confirm_dialog.dart';
import 'package:plansy_flutter_app/components/fields/input/build_web_site_text_form_field.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:plansy_flutter_app/components/buttons/basic/default_button.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/components/fields/input/build_duration_text_form_field_for_create.dart';
import 'package:plansy_flutter_app/components/fields/input/build_suitable_for_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_suitable_season_field.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/request.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

class CreateAttractionScreen3 extends StatefulWidget {
  final bool isAdmin;
  final String name;
  final String imageSrc;
  final String category;
  final String address;
  final String country;
  final String description;
  final TimeOfDay openingTime;
  final TimeOfDay closingTime;
  final String pricing;
  final String isNeedToBuyTickets;
  final Coordinates latLngLocation;

  const CreateAttractionScreen3({
    this.isAdmin,
    this.name,
    this.imageSrc,
    this.category,
    this.address,
    this.country,
    this.description,
    this.openingTime,
    this.closingTime,
    this.pricing,
    this.isNeedToBuyTickets,
    this.latLngLocation,
  });

  @override
  _CreateAttractionScreen3State createState() => _CreateAttractionScreen3State();
}

class _CreateAttractionScreen3State extends State<CreateAttractionScreen3> {
  final _formKey = GlobalKey<FormState>();

  String suitableFor = "";
  String suitableSeason = "";
  String webSite = "";
  TimeOfDay duration = TimeOfDay(hour: 0, minute: 0);

  String recommendations = "";
  String numOfReviews = "0";
  String rating = "0";

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
              // buildPage3Content
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  buildCreateAttractionForm(context),
                  buildSendToConfirmButton(
                    press: () async {
                      // do not delete this!
                      if (isSomethingWrong()) {}

                      if (_formKey.currentState.validate() && !isSomethingWrong()) {
                        _formKey.currentState.save();
                        await createAttractionRequest();
                      }
                    },
                  ),
                  buildAddButton(),
                  SizedBox(height: getProportionateScreenHeight(15)),
                ],
              ),
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

  Form buildCreateAttractionForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildSuitableForField(
            context: context,
            setSuitableFor: (newValue) => setState(() => suitableFor = newValue),
            initialValue: suitableFor,
            isUpdate: false,
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildSuitableSeasonField(
            context: context,
            setSuitableSeason: (newValue) => setState(() => suitableSeason = newValue),
            initialValue: suitableSeason,
            isUpdate: false,
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildWebSiteTextFormField(onSaved: (newValue) => webSite = newValue, isUpdate: false),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildDurationTextFormFieldForCreate(
            onSaved: (newValue) => duration = TimeOfDayExtension.timeFromStr(newValue),
            context: context,
            setDuration: (newValue) => setState(() => duration = newValue),
          ),
          SizedBox(height: getProportionateScreenHeight(40)),
        ],
      ),
    );
  }

  Visibility buildSendToConfirmButton({Function press}) {
    return Visibility(
      visible: !widget.isAdmin,
      child: DefaultButton(text: "Send to confirm", press: press, textColor: Colors.black),
    );
  }

  Future<void> createAttractionRequest() async {
    Attraction newAttraction = Attraction(
      status: 1,
      name: widget.name,
      imageSrc: widget.imageSrc,
      category: widget.category,
      address: widget.address,
      country: widget.country,
      description: widget.description,
      openingTime: widget.openingTime,
      closingTime: widget.closingTime,
      webSite: webSite,
      pricing: widget.pricing,
      isNeedToBuyTickets: widget.isNeedToBuyTickets,
      suitableFor: suitableFor,
      recommendations: recommendations,
      numOfReviews: numOfReviews,
      rating: rating,
      suitableSeason: suitableSeason,
      duration: duration,
      latLngLocation: widget.latLngLocation,
      priority: 0
    );
    await showSendToConfirmDialog(context: context, numOfPops: 4);
    Provider.of<Data>(context, listen: false).addRequestToFireBase(newAttraction, "-1");
  }

  Visibility buildAddButton() {
    return Visibility(
      visible: widget.isAdmin,
      child: DefaultButton(
        text: "Add",
        press: () {
          // do not delete this!
          if (isSomethingWrong()) {}

          if (_formKey.currentState.validate() && !isSomethingWrong()) {
            _formKey.currentState.save();
            createAttraction();
          }
        },
        textColor: Colors.black,
      ),
    );
  }

  bool isSomethingWrong() {
    return false;
  }

  void createAttraction() {
    Attraction newAttraction = Attraction(
      status: 1,
      name: widget.name,
      imageSrc: widget.imageSrc,
      category: widget.category,
      address: widget.address,
      country: widget.country,
      description: widget.description,
      openingTime: widget.openingTime,
      closingTime: widget.closingTime,
      webSite: webSite,
      pricing: widget.pricing,
      isNeedToBuyTickets: widget.isNeedToBuyTickets,
      suitableFor: suitableFor,
      recommendations: recommendations,
      numOfReviews: numOfReviews,
      rating: rating,
      suitableSeason: suitableSeason,
      duration: duration,
      latLngLocation: widget.latLngLocation,
    );
    Provider.of<Data>(context, listen: false).addAttraction(newAttraction);
    for (int i = 0; i < 3; i++) {
      Navigator.pop(context);
    }
  }
}
