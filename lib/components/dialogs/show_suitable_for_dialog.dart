import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/dialogs/basic/multi_select_dialog.dart';
import 'package:plansy_flutter_app/model/multi_select_dialog_item.dart';

List<MultiSelectDialogItem<int>> multiSuitableForOptionsItem = [];
Set<int> selectedSuitableForOptions;

final suitableForOptionsKeyValue = {
  1: "Children",
  2: "People with disabilities",
  3: "Adults",
  4: "Religious",
  5: "Couples",
  6: "Families",
  7: "Groups",
};

final suitableForOptionsValueKey = {
  "Children": 1,
  "People with disabilities": 2,
  "Adults": 3,
  "Religious": 4,
  "Couples": 5,
  "Families": 6,
  "Groups": 7,
};

void showSuitableForDialog(
    BuildContext context, Function setSuitableFor, String existingSuitableFor) async {
  multiSuitableForOptionsItem = [];
  populateSuitableForOptions();
  final items = multiSuitableForOptionsItem;

  List<int> initialValues = getInitialValuesKeysFromSuitableFor(existingSuitableFor);
  if (selectedSuitableForOptions != null) {
    selectedSuitableForOptions.forEach((element) => initialValues.add(element));
  }

  selectedSuitableForOptions = await showDialog<Set<int>>(
    context: context,
    builder: (BuildContext context) {
      return MultiSelectDialog(
        items: items,
        initialSelectedValues: initialValues.toSet(),
      );
    },
  );
  getSuitableForOptionsFromKey(setSuitableFor);
}

void populateSuitableForOptions() {
  for (int v in suitableForOptionsKeyValue.keys) {
    multiSuitableForOptionsItem.add(MultiSelectDialogItem(v, suitableForOptionsKeyValue[v]));
  }
}

void getSuitableForOptionsFromKey(Function setSuitableFor) {
  String tempSuitableForOption = "";

  if (selectedSuitableForOptions.isNotEmpty) {
    for (int x in selectedSuitableForOptions.toList()) {
      tempSuitableForOption += suitableForOptionsKeyValue[x];
      tempSuitableForOption += ", ";
    }
    tempSuitableForOption = tempSuitableForOption.substring(0, tempSuitableForOption.length - 2);
  }
  setSuitableFor(tempSuitableForOption);
}

List<int> getInitialValuesKeysFromSuitableFor(String initialValue) {
  List<int> keys = [];
  List<String> suitableFors = [];
  if (initialValue.isNotEmpty) {
    suitableFors = initialValue.split(", ");
    for (String i in suitableFors) {
      keys.add(suitableForOptionsValueKey[i]);
    }
  }
  return keys;
}