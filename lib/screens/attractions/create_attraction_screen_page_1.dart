import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:plansy_flutter_app/components/fields/input/build_category_field.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/components/fields/input/build_attraction_Image_src_text_form_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_attraction_name_text_form_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_description_text_form_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_address_text_form_field.dart';
import 'package:plansy_flutter_app/model/google_maps/google_maps_utilities.dart';
import 'package:plansy_flutter_app/screens/attractions/create_attraction_screen_page_2.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:http/http.dart' as http;

class CreateAttractionScreen1 extends StatefulWidget {
  final bool isAdmin;

  const CreateAttractionScreen1({this.isAdmin});

  @override
  _CreateAttractionScreen1State createState() => _CreateAttractionScreen1State();
}

class _CreateAttractionScreen1State extends State<CreateAttractionScreen1> {
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String imageSrc = "default_image.png";
  String category = "";
  String address = "";
  String country = "";
  String description = "";
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
              // buildPage1Content
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                  buildTitle(),
                  SizedBox(height: SizeConfig.screenHeight * 0.05),
                  buildCreateAttractionForm(context),
                  buildNextButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        bool isUrlValid = await checkIfImageURLValid(imageSrc);
                        if (!isUrlValid) {
                          useDefaultImage();
                        }
                        moveToNextPage();
                      }
                    },
                  ),
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

  Text buildTitle() {
    return Text("Add the attraction details:", style: k28BlackStyle, textAlign: TextAlign.center);
  }

  Form buildCreateAttractionForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildAttractionNameTextFormField(onSaved: (newValue) => name = newValue),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildImageSrcTextFormField(onSaved: (newValue) => imageSrc = newValue),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildCategoryField(
            context: context,
            setCategory: (newValue) => setState(() => category = newValue),
            initialValue: category,
            isUpdate: false,
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          BuildAddressTextFormField(
            onSaved: (newValue) => address = newValue,
            setLatLngLocation: (newValue) => setState(() => latLngLocation = newValue),
            setAddress: (newValue) async {
              setState(() => address = newValue);
              setState(() async => country = await findCountryFromAddress(address));
            },
            isEnabled: true,
            labelText: "* Address",
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildDescriptionTextFormField(
            onSaved: (newValue) => description = newValue,
            isUpdate: false,
            initialValue: description,
          ),
        ],
      ),
    );
  }

  Row buildNextButton({Function onPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: Text("NEXT >", style: TextStyle(color: kPrimaryColor)),
          onPressed: onPressed,
        ),
      ],
    );
  }

  Future checkIfImageURLValid(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      if (response.statusCode != 200) {
        return false;
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  void useDefaultImage() {
    setState(() => imageSrc = "default_image.png");
  }

  void moveToNextPage() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAttractionScreen2(
            isAdmin: widget.isAdmin,
            name: name,
            imageSrc: imageSrc,
            category: category,
            address: address,
            country: country,
            description: description,
            latLngLocation: latLngLocation,
          ),
        ),
      );
}
