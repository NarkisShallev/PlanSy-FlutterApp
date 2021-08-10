import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/dialogs/show_suitable_season_dialog.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

OutlinedButton buildSuitableSeasonField({
  BuildContext context,
  Function setSuitableSeason,
  bool isUpdate,
  String initialValue,
}) {
  return OutlinedButton(
    child: Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20), vertical: getProportionateScreenWidth(20)),
      child: Text(
        "Select for which season it's suitable  V",
        style: isUpdate ? k12BlackStyle : k13BlackStyle,
      ),
    ),
    onPressed: () => showSuitableSeasonDialog(context, setSuitableSeason, initialValue),
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: Colors.black, width: 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(getProportionateScreenWidth(28)))),
    ),
  );
}
