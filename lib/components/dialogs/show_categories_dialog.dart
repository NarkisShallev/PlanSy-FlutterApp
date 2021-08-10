import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/dialogs/basic/multi_select_dialog.dart';
import 'package:plansy_flutter_app/model/multi_select_dialog_item.dart';

List<MultiSelectDialogItem<int>> multiCategoriesItem = [];
Set<int> selectedCategories;

final categoriesOptionsKeyValue = {
  1: "Garden",
  2: "Funicular",
  3: "Ferry",
  4: "Monument/Statue",
  5: "Museum",
  6: "Religious/Holy site",
  7: "Market",
  8: "Sport",
  9: "Observation",
  10: "Bridge",
  11: "Park",
  12: "Historical site",
};

final categoriesOptionsValueKey = {
  "Garden": 1,
  "Funicular": 2,
  "Ferry": 3,
  "Monument/Statue": 4,
  "Museum": 5,
  "Religious/Holy site": 6,
  "Market": 7,
  "Sport": 8,
  "Observation": 9,
  "Bridge": 10,
  "Park": 11,
  "Historical site": 12,
};

void showCategories(
    BuildContext context, Function setStateCategory, String initialValue) async {
  multiCategoriesItem = [];
  populateCategories();
  final items = multiCategoriesItem;

  List<int> initialValues = getInitialValuesKeysFromCategory(initialValue);
  if (selectedCategories != null) {
    selectedCategories.forEach((element) => initialValues.add(element));
  }

  selectedCategories = await showDialog<Set<int>>(
    context: context,
    builder: (BuildContext context) {
      return MultiSelectDialog(
        items: items,
        initialSelectedValues: initialValues.toSet(),
      );
    },
  );
  getCategoryFromKeys(setStateCategory);
}

void populateCategories() {
  for (int v in categoriesOptionsKeyValue.keys) {
    multiCategoriesItem.add(MultiSelectDialogItem(v, categoriesOptionsKeyValue[v]));
  }
}

void getCategoryFromKeys(Function setStateCategory) {
  String tempCategory = "";

  if (selectedCategories.isNotEmpty) {
    for (int x in selectedCategories.toList()) {
      tempCategory += categoriesOptionsKeyValue[x];
      tempCategory += ", ";
    }
    tempCategory = tempCategory.substring(0, tempCategory.length - 2);
  }
  setStateCategory(tempCategory);
}

List<int> getInitialValuesKeysFromCategory(String existingCategory) {
  List<int> keys = [];
  List<String> categories = [];
  if (existingCategory.isNotEmpty) {
    categories = existingCategory.split(", ");
    for (String i in categories) {
      keys.add(categoriesOptionsValueKey[i]);
    }
  }
  return keys;
}
