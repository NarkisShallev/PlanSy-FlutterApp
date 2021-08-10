import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class SearchField extends StatelessWidget {
  final String name;
  final IconData icon;
  final String hintText;
  final Function onChanged;

  const SearchField({@required this.name, this.icon, this.hintText, @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20), vertical: getProportionateScreenWidth(5)),
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(25)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: kSecondaryColor.withOpacity(0.32)),
      ),
      child: Theme(
        data: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: null,
            focusedBorder: null,
            border: null,
          ),
        ),
        child: TextField(
          onChanged: onChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(icon),
            hintText: hintText,
            hintStyle: TextStyle(color: kSecondaryColor),
          ),
        ),
      ),
    );
  }
}
