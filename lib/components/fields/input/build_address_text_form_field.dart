import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:plansy_flutter_app/components/build_google_maps_icon.dart';
import 'package:plansy_flutter_app/components/suffixes/custom_suffix_widget.dart';
import 'package:plansy_flutter_app/model/google_maps/google_maps_pick_lat_lon.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

class BuildAddressTextFormField extends StatefulWidget {
  final Function onSaved;
  final Function setLatLngLocation;
  final Function setAddress;
  final String labelText;
  final bool isEnabled;
  final String initialValue;

  const BuildAddressTextFormField({
    this.onSaved,
    this.setLatLngLocation,
    this.setAddress,
    this.labelText,
    this.isEnabled,
    this.initialValue,
  });

  @override
  _BuildAddressTextFormFieldState createState() => _BuildAddressTextFormFieldState();
}

class _BuildAddressTextFormFieldState extends State<BuildAddressTextFormField> {
  Address location;
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_addressController.text == "") {
      _addressController.text = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      enabled: widget.isEnabled,
      initialValue: !widget.isEnabled ? widget.initialValue : null,
      controller: widget.isEnabled ? _addressController : null,
      onSaved: widget.onSaved,
      onChanged: (value) => null,
      validator: (value) {
        if (_addressController.text.isEmpty) {
          return kAddressNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Colors.black),
        hintText: "Pick with Google Maps",
        suffixIcon: buildGoogleMapsSuffix(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  CustomSuffixWidget buildGoogleMapsSuffix() {
    return CustomSuffixWidget(
      widget: buildGoogleMapsIcon(onTap: () => openDefaultGoogleMaps()),
    );
  }

  void openDefaultGoogleMaps() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoogleMapsPickLatLon(
          location: location,
          setLocation: (newValue) => setState(() {
            widget.setLatLngLocation(newValue.coordinates);
            location = newValue;
          }),
          setAddress: (newValue) => setState(() {
            widget.setAddress(newValue);
            _addressController.text = newValue;
          }),
        ),
      ),
    );
  }
}
