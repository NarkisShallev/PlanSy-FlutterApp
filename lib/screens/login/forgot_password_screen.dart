import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/components/buttons/basic/default_button.dart';
import 'package:plansy_flutter_app/components/dialogs/show_confirm_email_dialog.dart';
import 'package:plansy_flutter_app/components/fields/input/build_email_text_form_field.dart';
import 'package:plansy_flutter_app/screens/login/form_error.dart';
import 'package:plansy_flutter_app/screens/login/no_account_text.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email;
  List<String> errors = [];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context),
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Stack(
          children: [
            buildBackgroundColor(),
            SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                    child: buildForgotPasswordContent(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return myAppBar(
      context: context,
      isArrowBack: true,
      isNotification: false,
      isEdit: false,
      isSave: false,
      isTabBar: false,
      isShare: false,
      titleText: 'Forgot password',
      iconsColor: Colors.black,
    );
  }

  Opacity buildBackgroundColor() {
    return Opacity(
      opacity: 0.4,
      child: Image.asset(
        "images/login.jpg",
        height: getProportionateScreenWidth(double.infinity),
        fit: BoxFit.cover,
        alignment: Alignment.bottomCenter,
      ),
    );
  }

  Column buildForgotPasswordContent() {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        buildTitle(),
        SizedBox(height: SizeConfig.screenHeight * 0.1),
        buildForgotPasswordForm(),
      ],
    );
  }

  Column buildTitle() {
    return Column(
      children: [
        Text("Forgot password", style: k28BlackStyle),
        Text(
          "Please enter your email and we will send \nyou an email to reset your password",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Form buildForgotPasswordForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailTextFormField(
            onSaved: (newValue) => email = newValue,
            setChangeShowSpinner: (newValue) => setState(() => changeShowSpinner(newValue)),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildSendMeAnEmailButton(),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          NoAccountText(firstTextColor: Colors.black),
        ],
      ),
    );
  }

  void changeShowSpinner(bool value) => setState(() => _showSpinner = value);

  DefaultButton buildSendMeAnEmailButton() {
    return DefaultButton(
      text: "Send me an email",
      press: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          firebaseResetPassword();
        }
      },
      textColor: Colors.black,
    );
  }

  void firebaseResetPassword() async {
    changeShowSpinner(true);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      errors = [];
      await showConfirmEmailDialog(context);
    } catch (e) {
      errorsDealing(e);
    }
    changeShowSpinner(false);
  }

  void errorsDealing(dynamic e) {
    changeShowSpinner(false);
    errors = [];
    if ((e.code == 'invalid-email') || (e.code == 'network-request-failed')) {
      setState(() => errors.add("Error! " + e.code.replaceAll(RegExp('-'), ' ')));
    } else {
      setState(() => errors.add("Error! Something went wrong"));
    }
  }
}
