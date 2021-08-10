import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class CustomSuffixIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function onPressed;

  const CustomSuffixIconButton(
      {@required this.icon, @required this.color, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
        getProportionateScreenWidth(20),
      ),
      child: IconButton(
        icon: Icon(icon, size: getProportionateScreenWidth(25), color: color),
        onPressed: onPressed,
      ),
    );
  }
}
