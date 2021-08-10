import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/dialogs/show_suitable_for_dialog.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

OutlinedButton buildSuitableForField(
    {BuildContext context, Function setSuitableFor, bool isUpdate, String initialValue}) {
  return OutlinedButton(
    child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(45), vertical: getProportionateScreenWidth(20)),
      child:
          Text("Select for whom it's suitable  V", style: isUpdate ? k12BlackStyle : k13BlackStyle),
    ),
    onPressed: () => showSuitableForDialog(context, setSuitableFor, initialValue),
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: Colors.black, width: 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(getProportionateScreenWidth(28)))),
    ),
  );
}
