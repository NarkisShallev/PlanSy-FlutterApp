import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/dialogs/show_categories_dialog.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

OutlinedButton buildCategoryField(
    {BuildContext context, Function setCategory, bool isUpdate, String initialValue}) {
  return OutlinedButton(
    child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(83), vertical: getProportionateScreenWidth(20)),
      child: Text(
        "Select categories  V",
        style: isUpdate ? k12BlackStyle: k13BlackStyle,
      ),
    ),
    onPressed: () => showCategories(context, setCategory, initialValue),
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: Colors.black, width: 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(getProportionateScreenWidth(28)))),
    ),
  );
}
