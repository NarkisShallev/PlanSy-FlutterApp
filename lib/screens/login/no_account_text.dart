import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/screens/login/sign_up_screen.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class NoAccountText extends StatelessWidget {
  final Color firstTextColor;

  const NoAccountText({@required this.firstTextColor});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildDontHaveAnAccountText(),
        buildSignUpButton(context),
      ],
    );
  }

  TextButton buildSignUpButton(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen())),
      child: Text(
        "Sign up",
        style: TextStyle(fontSize: getProportionateScreenWidth(16), color: kPrimaryColor),
      ),
    );
  }

  Text buildDontHaveAnAccountText() {
    return Text(
      "Don't have an account? ",
      style: TextStyle(fontSize: getProportionateScreenWidth(16), color: firstTextColor),
    );
  }
}
