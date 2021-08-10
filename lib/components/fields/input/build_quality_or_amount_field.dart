import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

enum qualityOrAmountOptions { quality, amount }

qualityOrAmountOptions _option = qualityOrAmountOptions.quality;

OutlinedButton buildQualityOrAmountField({Function setQualityOrAmount, bool isEnabled}) {
  return OutlinedButton(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(5)),
      child: Column(
        children: [
          buildWhatIsMoreImportantToYouText(),
          Row(
            children: <Widget>[
              Expanded(
                child: buildQualityListTile(isEnabled, setQualityOrAmount),
              ),
              Expanded(
                child: buildAmountListTile(isEnabled, setQualityOrAmount),
              ),
            ],
          ),
        ],
      ),
    ),
    onPressed: () {},
    style: OutlinedButton.styleFrom(
      side: BorderSide(color: isEnabled ? Colors.black : Colors.grey[350], width: 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(getProportionateScreenWidth(28)))),
    ),
  );
}

Text buildWhatIsMoreImportantToYouText() {
  return Text("What is more important to you?", style: k13BlackStyle);
}

ListTile buildQualityListTile(bool isEnabled, Function setQualityOrAmount) {
  return ListTile(
    title: Text('quality', style: k13BlackStyle),
    leading: Radio<qualityOrAmountOptions>(
      value: qualityOrAmountOptions.quality,
      groupValue: _option,
      onChanged: (qualityOrAmountOptions value) =>
          onChangedQualityOrAmount(value, isEnabled, setQualityOrAmount),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    dense: true,
  );
}

ListTile buildAmountListTile(bool isEnabled, Function setQualityOrAmount) {
  return ListTile(
    title: Text('amount', style: k13BlackStyle),
    leading: Radio<qualityOrAmountOptions>(
      value: qualityOrAmountOptions.amount,
      groupValue: _option,
      onChanged: (qualityOrAmountOptions value) =>
          onChangedQualityOrAmount(value, isEnabled, setQualityOrAmount),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    ),
    dense: true,
  );
}

void onChangedQualityOrAmount(
    qualityOrAmountOptions value, bool isEnabled, Function setQualityOrAmount) {
  if (isEnabled) {
    _option = value;
    String optionStr = _option.toString().substring("qualityOrAmountOptions.".length);
    setQualityOrAmount(optionStr);
  }
}
