import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color textColor;
  final double width;

  const DefaultButton(
      {@required this.text, @required this.press, @required this.textColor, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: getProportionateScreenHeight(56),
      // ignore: deprecated_member_use
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: kPrimaryColor,
        onPressed: press,
        child: Text(
          text,
          style: TextStyle(fontSize: getProportionateScreenWidth(18), color: textColor),
        ),
      ),
    );
  }
}
