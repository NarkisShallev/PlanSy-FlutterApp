import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/currency_picker_dialog.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:country_currency_pickers/country_pickers.dart';

class BuildPricingField extends StatefulWidget {
  final Function setPricing;
  final bool isUpdate;
  final String initialValue;

  const BuildPricingField({this.setPricing, this.isUpdate, this.initialValue});

  @override
  _BuildPricingFieldState createState() => _BuildPricingFieldState();
}

class _BuildPricingFieldState extends State<BuildPricingField> {
  Country _selectedDialogCurrency = CountryPickerUtils.getCountryByCurrencyCode('USD');

  Map<String, double> pricingOptions = {
    "Adult": 0,
    "Child": 0,
    "Student": 0,
    "Disabled": 0,
  };

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue != null) {
      getPricingAndCurrencyFromString(widget.initialValue);
    }
    return OutlinedButton(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(5), vertical: getProportionateScreenWidth(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(visible: !widget.isUpdate, child: Text("Pricing:", style: k13BlackStyle)),
            buildPricingRow("Adult", widget.isUpdate),
            buildPricingRow("Child", widget.isUpdate),
            buildPricingRow("Student", widget.isUpdate),
            buildPricingRow("Disabled", widget.isUpdate),
            buildCurrencyPicker(context),
          ],
        ),
      ),
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.black, width: getProportionateScreenWidth(1)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(getProportionateScreenWidth(28)))),
      ),
    );
  }

  void getPricingAndCurrencyFromString(String initialValue) {
    List<String> lines;
    List<String> splitLine;
    if (initialValue != "") {
      lines = initialValue.split(", ");
      splitLine = lines[0].split(" ");
      pricingOptions["Adult"] = double.parse(splitLine[1]);
      splitLine = lines[1].split(" ");
      pricingOptions["Child"] = double.parse(splitLine[1]);
      splitLine = lines[2].split(" ");
      pricingOptions["Student"] = double.parse(splitLine[1]);
      splitLine = lines[3].split(" ");
      pricingOptions["Disabled"] = double.parse(splitLine[1]);
      _selectedDialogCurrency = CountryPickerUtils.getCountryByCurrencyCode(splitLine[2]);
    }
  }

  Row buildPricingRow(String title, bool isUpdate) {
    TextEditingController _pricingController = TextEditingController();
    _pricingController.text = pricingOptions[title].toString();
    return Row(
      children: [
        Text(title, style: isUpdate ? k12BlackStyle : k13BlackStyle),
        Spacer(),
        buildAddIconButton(title, _pricingController, widget.isUpdate),
        SizedBox(width: getProportionateScreenWidth(20)),
        Container(
          width: getProportionateScreenWidth(70),
          child: buildPricingTextFormField(_pricingController, title, widget.isUpdate),
        ),
        SizedBox(width: getProportionateScreenWidth(20)),
        buildRemoveIconButton(title, _pricingController, isUpdate),
        SizedBox(width: getProportionateScreenWidth(20)),
      ],
    );
  }

  Ink buildAddIconButton(String title, TextEditingController _pricingController, bool isUpdate) {
    return Ink(
      width: isUpdate ? getProportionateScreenWidth(30) : getProportionateScreenWidth(35),
      height: isUpdate ? getProportionateScreenWidth(30) : getProportionateScreenHeight(35),
      decoration: ShapeDecoration(shape: CircleBorder(), color: kPrimaryColor),
      child: IconButton(
        icon: Icon(Icons.add),
        iconSize: isUpdate ? getProportionateScreenWidth(16) : getProportionateScreenWidth(20),
        color: Colors.white,
        onPressed: () {
          if (pricingOptions[title] != 9999) {
            pricingOptions[title]++;
            _pricingController.text = (double.parse(_pricingController.text) + 1).toString();
          }
          getPricingString();
        },
      ),
    );
  }

  TextFormField buildPricingTextFormField(
      TextEditingController _pricingController, String title, bool isUpdate) {
    return TextFormField(
      style: isUpdate ? k12BlackStyle : k13BlackStyle,
      onSaved: (newValue) => getPricingString(),
      controller: _pricingController,
      inputFormatters: [
        // ignore: deprecated_member_use
        WhitelistingTextInputFormatter(RegExp("[0-9.]")),
      ],
      onChanged: (value) {
        if (double.parse(value) <= 9999) {
          pricingOptions[title] = double.parse(value);
        } else {
          _pricingController.text = pricingOptions[title].toString();
        }
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(5), vertical: getProportionateScreenWidth(5)),
      ),
    );
  }

  Ink buildRemoveIconButton(String title, TextEditingController _pricingController, bool isUpdate) {
    return Ink(
      width: isUpdate ? getProportionateScreenWidth(30) : getProportionateScreenWidth(35),
      height: isUpdate ? getProportionateScreenWidth(30) : getProportionateScreenWidth(35),
      decoration: ShapeDecoration(shape: CircleBorder(), color: kPrimaryColor),
      child: IconButton(
        icon: Icon(Icons.remove),
        iconSize: isUpdate ? getProportionateScreenWidth(16) : getProportionateScreenWidth(20),
        color: Colors.white,
        onPressed: () {
          if (pricingOptions[title] != 0) {
            pricingOptions[title]--;
            _pricingController.text = (double.parse(_pricingController.text) - 1).toString();
          }
          getPricingString();
        },
      ),
    );
  }

  void getPricingString() {
    bool isExistPriceNotZero = false;
    String tempPricing = "";

    for (var k in pricingOptions.keys) {
      if (pricingOptions[k] != 0) {
        isExistPriceNotZero = true;
      }
      tempPricing += k;
      tempPricing += ": ";
      tempPricing += pricingOptions[k].toString();
      tempPricing += " ";
      tempPricing += _selectedDialogCurrency.currencyCode;
      tempPricing += ", ";
    }
    tempPricing = tempPricing.substring(0, tempPricing.length - 2);
    if (isExistPriceNotZero) {
      widget.setPricing(tempPricing);
    } else {
      widget.setPricing("");
    }
  }

  OutlinedButton buildCurrencyPicker(BuildContext context) {
    return OutlinedButton(
        onPressed: () => openCurrencyPickerDialog(context),
        child: buildCurrencyDialogItem(_selectedDialogCurrency));
  }

  Future<void> openCurrencyPickerDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.black),
        child: CurrencyPickerDialog(
          titlePadding: EdgeInsets.all(getProportionateScreenWidth(8)),
          searchInputDecoration: InputDecoration(hintText: 'Search...'),
          isSearchable: true,
          title: Text('Select your Currency'),
          onValuePicked: (Country country) {
            setState(() {});
            _selectedDialogCurrency = country;
            getPricingString();
          },
          itemBuilder: buildCurrencyDialogItem,
        ),
      ),
    );
  }

  Widget buildCurrencyDialogItem(Country country) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(width: getProportionateScreenWidth(8)),
        Text("(${country.currencyCode})", style: TextStyle(color: Colors.black)),
        SizedBox(width: getProportionateScreenWidth(8)),
        Flexible(child: Text(country.name ?? '', style: TextStyle(color: Colors.black)))
      ],
    );
  }
}
