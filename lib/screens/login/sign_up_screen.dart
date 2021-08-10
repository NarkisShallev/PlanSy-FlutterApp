import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/components/buttons/basic/default_button.dart';
import 'package:plansy_flutter_app/components/dialogs/show_confirm_email_dialog.dart';
import 'package:plansy_flutter_app/components/fields/input/build_confirm_password_text_form_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_email_text_form_field.dart';
import 'package:plansy_flutter_app/components/fields/input/build_password_text_form_field.dart';
import 'package:plansy_flutter_app/screens/login/form_error.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String confirmPassword;
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
                    child: buildSignUpContent(),
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
      titleText: 'Sign up',
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

  Column buildSignUpContent() {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.02),
        buildTitle(),
        SizedBox(height: SizeConfig.screenHeight * 0.07),
        buildSignUpForm(),
        SizedBox(height: SizeConfig.screenHeight * 0.07),
        buildTermAndConditionText()
      ],
    );
  }

  Column buildTitle() {
    return Column(
      children: [
        Text("Sign up", style: k28BlackStyle),
        Text("Complete your details"),
      ],
    );
  }

  Form buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailTextFormField(
            onSaved: (newValue) => email = newValue,
            setChangeShowSpinner: (newValue) => setState(() => changeShowSpinner(newValue)),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordTextFormField(
            onSaved: (newValue) => password = newValue,
            setChangeShowSpinner: (newValue) => setState(() => changeShowSpinner(newValue)),
            setPassword: (newValue) => setState(() => password = newValue),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConfirmPasswordFormField(
            onSaved: (newValue) => confirmPassword = newValue,
            password: password,
            setChangeShowSpinner: (newValue) => setState(() => changeShowSpinner(newValue)),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          buildSignUpButton()
        ],
      ),
    );
  }

  void changeShowSpinner(bool value) => setState(() => _showSpinner = value);

  DefaultButton buildSignUpButton() {
    return DefaultButton(
        text: "Sign up",
        press: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            firebaseRegister();
          }
        },
        textColor: Colors.black);
  }

  void firebaseRegister() async {
    changeShowSpinner(true);
    try {
      UserCredential newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await newUser.user.sendEmailVerification();
      _auth.signOut();
      if ((newUser != null)) {
        errors = [];
        await showConfirmEmailDialog(context);
      }
      changeShowSpinner(false);
    } catch (e) {
      errorsDealing(e);
    }
  }

  void errorsDealing(dynamic e) {
    changeShowSpinner(false);
    errors = [];
    if ((e.code == 'email-already-in-use') || (e.code == 'network-request-failed')) {
      setState(() => errors.add("Error! " + e.code.replaceAll(RegExp('-'), ' ')));
    } else {
      setState(() => errors.add("Error! Something went wrong"));
    }
  }

  Text buildTermAndConditionText() {
    return Text(
      "By continuing you are confirm that you agree \nwith our Term and Condition",
      textAlign: TextAlign.center,
    );
  }
}
