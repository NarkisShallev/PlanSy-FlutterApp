import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/components/buttons/basic/default_button.dart';
import 'package:plansy_flutter_app/components/fields/input/build_email_text_form_field_white_style.dart';
import 'package:plansy_flutter_app/components/fields/input/build_password_text_form_field_white_style.dart';
import 'package:plansy_flutter_app/model/FireBase/FireBaseSingelton.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/screens/home/admin_home_screen.dart';
import 'package:plansy_flutter_app/screens/home/home_screen.dart';
import 'package:plansy_flutter_app/screens/login/forgot_password_screen.dart';
import 'package:plansy_flutter_app/screens/login/form_error.dart';
import 'package:plansy_flutter_app/screens/login/no_account_text.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool isRememberMeChecked = false;
  List<String> errors = [];

  @override
  void initState() {
    super.initState();
    loadUserEmailPassword();
  }

  void loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _remeberMe = _prefs.getBool("remember_me") ?? false;
      if (_remeberMe) {
        setState(() => isRememberMeChecked = true);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context),
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        child: Stack(
          children: <Widget>[
            buildBackgroundColor(),
            SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
                  child: SingleChildScrollView(
                    child: buildSignInContent(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return myAppBar(
      context: context,
      isArrowBack: false,
      isNotification: false,
      isEdit: false,
      isSave: false,
      isTabBar: false,
      isShare: false,
      titleText: '',
      iconsColor: Colors.black,
    );
  }

  Image buildBackgroundColor() {
    return Image.asset(
      "images/login.jpg",
      height: getProportionateScreenWidth(double.infinity),
      fit: BoxFit.cover,
      alignment: Alignment.bottomCenter,
    );
  }

  Column buildSignInContent() {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.04),
        buildTitle(),
        SizedBox(height: SizeConfig.screenHeight * 0.07),
        buildSignInForm(),
        SizedBox(height: SizeConfig.screenHeight * 0.07),
        NoAccountText(firstTextColor: Colors.white),
      ],
    );
  }

  Column buildTitle() {
    return Column(
      children: [
        Center(
          child: Text(
            "PlanSy",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(70),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          "Welcome! Sign in with your email and password",
          style: TextStyle(fontSize: getProportionateScreenWidth(15), color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Form buildSignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          BuildEmailTextFormFieldWhiteStyle(
            onSaved: (newValue) => email = newValue,
            setChangeShowSpinner: (newValue) => setState(() => changeShowSpinner(newValue)),
            setEmail: (newValue) => setState(() => email = newValue),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          BuildPasswordTextFormFieldWhiteStyle(
            onSaved: (newValue) => password = newValue,
            setChangeShowSpinner: (newValue) => setState(() => changeShowSpinner(newValue)),
            setPassword: (newValue) => setState(() => password = newValue),
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          Row(
            children: [
              buildRememberMeCheckBox(),
              buildRememberMeText(),
              Spacer(),
              buildForgotPasswordButton(context)
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          buildSignInButton(),
        ],
      ),
    );
  }

  void changeShowSpinner(bool value) => setState(() => _showSpinner = value);

  Theme buildRememberMeCheckBox() {
    return Theme(
      data: ThemeData(unselectedWidgetColor: Colors.white),
      child: Checkbox(
        value: isRememberMeChecked,
        activeColor: kPrimaryColor,
        onChanged: (value) {
          SharedPreferences.getInstance().then(
            (prefs) {
              prefs.setBool("remember_me", value);
              prefs.setString('email', email);
              prefs.setString('password', password);
            },
          );
          setState(() => isRememberMeChecked = value);
        },
      ),
    );
  }

  Text buildRememberMeText() => Text("Remember me", style: TextStyle(color: Colors.white));

  TextButton buildForgotPasswordButton(BuildContext context) {
    return TextButton(
      onPressed: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen())),
      child: Text(
        "Forgot password?",
        style: TextStyle(decoration: TextDecoration.underline, color: Colors.white),
      ),
    );
  }

  DefaultButton buildSignInButton() {
    return DefaultButton(
      text: "Sign in",
      press: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          firebaseLogin();
        }
      },
      textColor: Colors.white,
    );
  }

  void firebaseLogin() async {
    changeShowSpinner(true);
    try {
      UserCredential user =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      if ((!user.user.emailVerified) && (user.user.email != "admin@gmail.com")) {
        unverifiedUserDealing();
      } else {
        if (user != null) {
          if (user.user.email == "admin@gmail.com") {
            Provider.of<Data>(context, listen: false).setUser(user.user);
            await FireBaseSingleton().loadAdmin(email, context);
            adminDealing();
          } else {
            bool isUserExistsInDB = await FireBaseSingleton().checkIfUserExistsInDB(email);
            Provider.of<Data>(context, listen: false).setUser(user.user);
            if (isUserExistsInDB) {
              await FireBaseSingleton().loadUser(email, context);
            } else {
              FireBaseSingleton().uploadUser(email, context);
            }
            verifiedAndRegisteredUserDealing();
          }
        }
      }
      changeShowSpinner(false);
    } catch (e) {
      errorsDealing(e);
    }
  }

  void errorsDealing(dynamic e) {
    changeShowSpinner(false);
    errors = [];
    if ((e.code == 'invalid-email') ||
        (e.code == 'wrong-password') ||
        (e.code == 'user-not-found') ||
        (e.code == 'user-disabled') ||
        (e.code == 'network-request-failed')) {
      setState(() => errors.add("Error! " + e.code.replaceAll(RegExp('-'), ' ')));
    } else {
      setState(() => errors.add("Error! Something went wrong"));
    }
  }

  void unverifiedUserDealing() {
    errors = [];
    if (!errors.contains(kEmailUnverified)) {
      setState(() => errors.add(kEmailUnverified));
    }
  }

  void adminDealing() =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHomeScreen()));

  void verifiedAndRegisteredUserDealing() {
    errors = [];
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
