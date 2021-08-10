import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

CSCPicker buildCountryStateCityField(
    {DefaultCountry defaultCountry, Function setCountry, Function setState, Function setCity}) {
  return CSCPicker(
    flagState: CountryFlag.ENABLE,
    dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(getProportionateScreenWidth(28))),
        color: Colors.white,
        border: Border.all(color: Colors.black)),
    disabledDropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(getProportionateScreenWidth(28))),
        color: Colors.grey.shade300,
        border: Border.all(color: Colors.black)),
    defaultCountry: defaultCountry ?? null,
    searchBarRadius: getProportionateScreenWidth(28),
    onCountryChanged: (value) => setCountry(value),
    onStateChanged: (value) => setState(value),
    onCityChanged: (value) => setCity(value),
  );
}
