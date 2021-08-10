import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:plansy_flutter_app/components/suffixes/custom_suffix_icon_button.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

class BuildNumOfHoursPerDayTextFormFieldForCreate extends StatefulWidget {
  final MaskTextInputFormatter formatter = MaskTextInputFormatter(mask: "##:##");
  final Function onSaved;
  final BuildContext context;
  final Function setNumOfHoursPerDay;

  BuildNumOfHoursPerDayTextFormFieldForCreate({this.onSaved, this.context, this.setNumOfHoursPerDay});

  @override
  _BuildNumOfHoursPerDayTextFormFieldForCreateState createState() =>
      _BuildNumOfHoursPerDayTextFormFieldForCreateState();
}

class _BuildNumOfHoursPerDayTextFormFieldForCreateState extends State<BuildNumOfHoursPerDayTextFormFieldForCreate> {
  TextEditingController _numOfHoursPerDayController = TextEditingController();
  TimeOfDay numOfHoursPerDay = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay hours;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(5),
        // ignore: deprecated_member_use
        WhitelistingTextInputFormatter(RegExp("[0-9:]")),
        widget.formatter
      ],
      controller: _numOfHoursPerDayController,
      onSaved: widget.onSaved,
      onChanged: (value) => null,
      validator: (value) {
        if (value.isEmpty) {
          return kNumberOfHoursPerDayNullError;
        }
        if (value.isNotEmpty && !isTimeValid(value)) {
          return kInvalidNumberError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "* Number of hours per day",
        labelStyle: TextStyle(color: Colors.black),
        hintText: "hh:mm",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIconButton(
          icon: Icons.access_time,
          color: Colors.black,
          onPressed: () async {
            await pickTime24Hour(context);
            updateVars(widget.setNumOfHoursPerDay);
          },
        ),
      ),
    );
  }

  bool isTimeValid(String time) {
    RegExp validTime24Hours = RegExp(r'^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$'); //hh:mm
    if (!validTime24Hours.hasMatch(time)) {
      return false;
    }
    return true;
  }

  Future pickTime24Hour(BuildContext context) async {
    final newTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 00, minute: 00),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });
    if (newTime == null) return;

    hours = newTime;
  }

  void updateVars(Function setDuration) {
    numOfHoursPerDay =
        TimeOfDayExtension.timeFromStr(hours.toString().substring(10, hours.toString().length - 1));
    setDuration(numOfHoursPerDay);
    if (numOfHoursPerDay != null) {
      _numOfHoursPerDayController.text = numOfHoursPerDay.str();
    }
  }
}
