import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class AttractionDetailsCard extends StatelessWidget {
  final Widget child;
  final double height;

  const AttractionDetailsCard({@required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: Colors.white,
      width: getProportionateScreenWidth(1000),
      height: height,
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(8)),
        child: Material(color: Colors.transparent, child: child),
      ),
    );
  }
}
