import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/suffixes/custom_suffix_icon.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuildPasswordTextFormFieldWhiteStyle extends StatefulWidget {
  final Function onSaved;
  final Function setChangeShowSpinner;
  final Function setPassword;

  const BuildPasswordTextFormFieldWhiteStyle(
      {this.onSaved, this.setChangeShowSpinner, this.setPassword});

  @override
  _BuildPasswordTextFormFieldWhiteStyleState createState() =>
      _BuildPasswordTextFormFieldWhiteStyleState();
}

class _BuildPasswordTextFormFieldWhiteStyleState
    extends State<BuildPasswordTextFormFieldWhiteStyle> {
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserEmailPassword();
  }

  void loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _password = _prefs.getString("password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;
      if (_remeberMe) {
        _passwordController.text = _password ?? "";
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      style: TextStyle(color: Colors.white),
      obscureText: true,
      onSaved: widget.onSaved,
      onChanged: (value) {
        if (widget.setPassword != null) {
          widget.setPassword(value);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          widget.setChangeShowSpinner(false);
          return kPassNullError;
        }
        if (value.length < 6) {
          widget.setChangeShowSpinner(false);
          return kShortPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "* Password",
        labelStyle: TextStyle(color: Colors.white),
        hintText: "Enter your password",
        hintStyle: TextStyle(color: Colors.white54),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(icon: Icons.lock_outline, color: Colors.white),
        // change the border color only in this widget
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
