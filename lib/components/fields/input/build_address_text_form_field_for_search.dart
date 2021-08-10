import 'package:flutter/material.dart';

class BuildAddressTextFormFieldForSearch extends StatefulWidget {
  final Function onChanged;

  const BuildAddressTextFormFieldForSearch({this.onChanged});

  @override
  _BuildAddressTextFormFieldForSearchState createState() =>
      _BuildAddressTextFormFieldForSearchState();
}

class _BuildAddressTextFormFieldForSearchState extends State<BuildAddressTextFormFieldForSearch> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      validator: (value) => null,
      decoration: InputDecoration(
        fillColor: Colors.white70,
        filled: true,
        hintText: "Enter address or pick from map",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          gapPadding: 10,
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          gapPadding: 10,
          borderSide: BorderSide(color: Colors.grey),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          gapPadding: 10,
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
