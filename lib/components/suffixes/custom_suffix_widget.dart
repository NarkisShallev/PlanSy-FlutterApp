import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class CustomSuffixWidget extends StatelessWidget {
  final Widget widget;

  const CustomSuffixWidget({this.widget});

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
      child: widget,
    );
  }
}
