import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/suffixes/custom_suffix_icon.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuildEmailTextFormFieldWhiteStyle extends StatefulWidget {
  final Function onSaved;
  final Function setChangeShowSpinner;
  final Function setEmail;

  const BuildEmailTextFormFieldWhiteStyle({this.onSaved, this.setChangeShowSpinner, this.setEmail});

  @override
  State<BuildEmailTextFormFieldWhiteStyle> createState() =>
      _BuildEmailTextFormFieldWhiteStyleState();
}

class _BuildEmailTextFormFieldWhiteStyleState extends State<BuildEmailTextFormFieldWhiteStyle> {
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserEmailPassword();
  }

  void loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;
      if (_remeberMe) {
        _emailController.text = _email ?? "";
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      style: TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      onSaved: widget.onSaved,
      onChanged: (value) {
        if (widget.setEmail != null) {
          widget.setEmail(value);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          widget.setChangeShowSpinner(false);
          return kEmailNullError;
        }
        if (!emailValidatorRegExp.hasMatch(value)) {
          widget.setChangeShowSpinner(false);
          return kInvalidEmailError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "* Email",
        labelStyle: TextStyle(color: Colors.white),
        hintText: "Enter your email",
        hintStyle: TextStyle(color: Colors.white54),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(icon: Icons.mail_outline, color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          gapPadding: 10,
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          gapPadding: 10,
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          gapPadding: 10,
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
