import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/buttons/basic/default_button.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class AddToTripButton extends StatelessWidget {
  final Function press;

  const AddToTripButton({this.press});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(25)),
      child: DefaultButton(
        text: "Add to trip",
        press: press,
        textColor: Colors.black,
      ),
    );
  }
}
