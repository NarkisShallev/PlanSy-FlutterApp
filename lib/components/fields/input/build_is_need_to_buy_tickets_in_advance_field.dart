import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

enum isNeedToBuyTicketsOptions { yes, no }

class BuildIsNeedToBuyTicketsField extends StatefulWidget {
  final Function setIsNeedToBuyTickets;
  final bool isUpdate;
  final String initialValue;

  const BuildIsNeedToBuyTicketsField(
      {this.setIsNeedToBuyTickets, this.isUpdate, this.initialValue});

  @override
  _BuildIsNeedToBuyTicketsFieldState createState() => _BuildIsNeedToBuyTicketsFieldState();
}

class _BuildIsNeedToBuyTicketsFieldState extends State<BuildIsNeedToBuyTicketsField> {
  isNeedToBuyTicketsOptions _option = isNeedToBuyTicketsOptions.no;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      if (widget.initialValue == "yes") {
        _option = isNeedToBuyTicketsOptions.yes;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(5), vertical: getProportionateScreenWidth(5)),
        child: Column(
          children: [
            buildIsNeedToBuyTicketsText(widget.isUpdate),
            Row(
              children: <Widget>[
                Expanded(
                  child: buildYesListTile(widget.setIsNeedToBuyTickets, widget.isUpdate),
                ),
                Expanded(
                  child: buildNoListTile(widget.setIsNeedToBuyTickets, widget.isUpdate),
                ),
              ],
            ),
          ],
        ),
      ),
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.black, width: 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(getProportionateScreenWidth(28)))),
      ),
    );
  }

  Visibility buildIsNeedToBuyTicketsText(bool isUpdate) {
    return Visibility(
      visible: !isUpdate,
      child: Text("Is need to buy tickets?", style: isUpdate ? k12BlackStyle : k13BlackStyle),
    );
  }

  ListTile buildYesListTile(Function setIsNeedToBuyTickets, bool isUpdate) {
    return ListTile(
      title: Text('yes', style: isUpdate ? k12BlackStyle : k13BlackStyle),
      leading: Radio<isNeedToBuyTicketsOptions>(
        value: isNeedToBuyTicketsOptions.yes,
        groupValue: _option,
        onChanged: (isNeedToBuyTicketsOptions value) => onChangedYesOrNo(value),
      ),
    );
  }

  ListTile buildNoListTile(Function setIsNeedToBuyTickets, bool isUpdate) {
    return ListTile(
      title: Text('no', style: isUpdate ? k12BlackStyle : k13BlackStyle),
      leading: Radio<isNeedToBuyTicketsOptions>(
        value: isNeedToBuyTicketsOptions.no,
        groupValue: _option,
        onChanged: (isNeedToBuyTicketsOptions value) => onChangedYesOrNo(value),
      ),
    );
  }

  void onChangedYesOrNo(isNeedToBuyTicketsOptions value) {
    _option = value;
    String optionStr = _option.toString().substring("isNeedToBuyTicketsOptions.".length);
    widget.setIsNeedToBuyTickets(optionStr);
  }
}
