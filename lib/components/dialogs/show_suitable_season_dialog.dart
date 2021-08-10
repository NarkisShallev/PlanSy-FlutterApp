import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/dialogs/basic/multi_select_dialog.dart';
import 'package:plansy_flutter_app/model/multi_select_dialog_item.dart';

List<MultiSelectDialogItem<int>> multiSuitableSeasonOptionsItem = [];
Set<int> selectedSuitableSeasonOptions;

final suitableSeasonOptionsKeyValue = {
  1: "Winter",
  2: "Summer",
  3: "Autumn",
  4: "Spring",
};

final suitableSeasonOptionsValueKey = {
  "Winter": 1,
  "Summer": 2,
  "Autumn": 3,
  "Spring": 4,
};

void showSuitableSeasonDialog(
    BuildContext context, Function setSuitableSeason, String initialValue) async {
  multiSuitableSeasonOptionsItem = [];
  populateSuitableSeasonOptions();
  final items = multiSuitableSeasonOptionsItem;

  List<int> initialValues = getInitialValuesKeysFromSuitableSeason(initialValue);
  if (selectedSuitableSeasonOptions != null) {
    selectedSuitableSeasonOptions.forEach((element) => initialValues.add(element));
  }

  selectedSuitableSeasonOptions = await showDialog<Set<int>>(
    context: context,
    builder: (BuildContext context) {
      return MultiSelectDialog(
        items: items,
        initialSelectedValues: initialValues.toSet(),
      );
    },
  );
  getSuitableSeasonOptionsFromKey(setSuitableSeason);
}

void populateSuitableSeasonOptions() {
  for (int v in suitableSeasonOptionsKeyValue.keys) {
    multiSuitableSeasonOptionsItem.add(MultiSelectDialogItem(v, suitableSeasonOptionsKeyValue[v]));
  }
}

void getSuitableSeasonOptionsFromKey(Function setSuitableSeason) {
  String tempSuitableSeasonOption = "";

  if (selectedSuitableSeasonOptions.isNotEmpty) {
    for (int x in selectedSuitableSeasonOptions.toList()) {
      tempSuitableSeasonOption += suitableSeasonOptionsKeyValue[x];
      tempSuitableSeasonOption += ", ";
    }
    tempSuitableSeasonOption =
        tempSuitableSeasonOption.substring(0, tempSuitableSeasonOption.length - 2);
  }
  setSuitableSeason(tempSuitableSeasonOption);
}

List<int> getInitialValuesKeysFromSuitableSeason(String existingSuitableSeason) {
  List<int> keys = [];
  List<String> suitableSeasons = [];
  if (existingSuitableSeason.isNotEmpty) {
    suitableSeasons = existingSuitableSeason.split(", ");
    for (String i in suitableSeasons) {
      keys.add(suitableSeasonOptionsValueKey[i]);
    }
  }
  return keys;
}
