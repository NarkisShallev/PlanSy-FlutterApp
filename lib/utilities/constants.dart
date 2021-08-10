import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

const kavgKmPerHour = 80;
const kPrimaryColor = Colors.cyan;
const kSecondaryColor = Colors.black45;
const kIconColor = Color(0xFF5E5E5E);

final kDefaultShadow = BoxShadow(
  offset: Offset(5, 5),
  blurRadius: getProportionateScreenWidth(10),
  color: Color(0xFFE9E9E9).withOpacity(0.56),
);

// Form Error
final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

const String kNameNullError = "Please enter your name";
const String kDescriptionNullError = "Please enter description";
const String kAddressNullError = "Please enter address";
const String kTitleNullError = "Please enter a title";
const String kCountryNullError = "Please enter a country";
const String kAttractionNameNullError = "Please enter the attraction's name";

const String kEmailNullError = "Please enter your email";
const String kInvalidEmailError = "Email is invalid!";
const String kEmailUnverified = "Please verify your email";

const String kPassNullError = "Please enter your password";
const String kShortPassError = "Password is too short!";
const String kMatchPassError = "Passwords don't match!";

const String kFromDateNullError = "Please enter beginning date";
const String kInvalidFromDateError = "Beginning date is invalid!";

const String kUntilDateNullError = "Please enter ending date";
const String kInvalidUntilDateError = "Ending date is invalid!";

const String kNumberOfHoursPerDayNullError = "Please enter number of hours per day";
const String kInvalidNumberError = "Number is invalid!";

const String kDurationNullError = "Please enter duration";
const String kInvalidDurationError = "Duration is invalid!";

const String kStartingHourNullError = "Please enter starting hour";
const String kInvalidStartingHourError = "Starting hour is invalid!";

const String kOpeningTimeNullError = "Please enter opening time";
const String kInvalidOpeningTimeError = "Opening time is invalid!";

const String kClosingTimeNullError = "Please enter closing time";
const String kInvalidClosingTimeError = "Closing time is invalid!";

const String kHttpsError = "Please enter a url starting with https";
const String kImageFormatError = "Please enter a url ending with jpg/jpeg/png";

// black big title
final kk48BlackStyle = TextStyle(
  fontSize: getProportionateScreenWidth(48.0),
  color: Colors.black,
);

// black medium title (heading style)
final k28BlackStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28.0),
  color: Colors.black,
);

// black title
final k18BlackStyle = TextStyle(
  fontSize: getProportionateScreenWidth(18.0),
  color: Colors.black,
);

// black small title
final k15BlackStyle = TextStyle(
  fontSize: getProportionateScreenWidth(15.0),
  color: Colors.black,
);

// black subtitle
final k13BlackStyle = TextStyle(
  fontSize: getProportionateScreenWidth(13.0),
  color: Colors.black,
);

// red subtitle
final k13RedStyle = TextStyle(
  fontSize: getProportionateScreenWidth(13.0),
  color: Colors.red,
);

// green subtitle
final k13GreenStyle = TextStyle(
  fontSize: getProportionateScreenWidth(13.0),
  color: Colors.green,
);

final k13PrimaryColorStyle = TextStyle(
  fontSize: getProportionateScreenWidth(13.0),
  color: kPrimaryColor,
);

final k12BlackStyle = TextStyle(
  fontSize: getProportionateScreenWidth(12.0),
  color: Colors.black,
);

// red error like the textFormField validation error
final k11Point5RedStyle = TextStyle(
  fontSize: getProportionateScreenWidth(11.5),
  color: Colors.red[800],
);
