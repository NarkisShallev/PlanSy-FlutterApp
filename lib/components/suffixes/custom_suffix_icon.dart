import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class CustomSuffixIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const CustomSuffixIcon({@required this.icon, @required this.color});

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
      child: Icon(icon, size: getProportionateScreenWidth(25), color: color),
    );
  }
}
