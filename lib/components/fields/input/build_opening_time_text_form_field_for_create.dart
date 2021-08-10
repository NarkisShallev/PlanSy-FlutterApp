import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:plansy_flutter_app/components/suffixes/custom_suffix_icon_button.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

class BuildOpeningTimeFormFieldForCreate extends StatefulWidget {
  final MaskTextInputFormatter formatter = MaskTextInputFormatter(mask: "##:##");
  final Function onSaved;
  final BuildContext context;
  final Function setOpeningTime;
  final TimeOfDay closingTime;

  BuildOpeningTimeFormFieldForCreate(
      {this.onSaved, this.context, this.setOpeningTime, this.closingTime});

  @override
  _BuildOpeningTimeFormFieldForCreateState createState() =>
      _BuildOpeningTimeFormFieldForCreateState();
}

class _BuildOpeningTimeFormFieldForCreateState extends State<BuildOpeningTimeFormFieldForCreate> {
  TextEditingController _openingTimeController = TextEditingController();
  TimeOfDay openingTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay time;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(5),
// ignore: deprecated_member_use
        WhitelistingTextInputFormatter(RegExp("[0-9:]")),
        widget.formatter
      ],
      controller: _openingTimeController,
      onSaved: widget.onSaved,
      onChanged: (value) {
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return kOpeningTimeNullError;
        }
        if (value.isNotEmpty && !isTimeValid(value, widget.closingTime)) {
          return kInvalidOpeningTimeError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "* Opening time",
        labelStyle: TextStyle(color: Colors.black),
        hintText: "hh:mm",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIconButton(
          icon: Icons.access_time,
          color: Colors.black,
          onPressed: () async {
            await pickTime24Hour(context);
            updateVars(widget.setOpeningTime);
          },
        ),
      ),
    );
  }

  bool isTimeValid(String time, TimeOfDay closingTime) {
    RegExp validTime24Hours = RegExp(r'^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$'); //hh:mm
    if (!validTime24Hours.hasMatch(time)) {
      return false;
    }
    if (closingTime != null) {
      if (openingTime >= closingTime) {
        return false;
      }
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

    time = newTime;
  }

  void updateVars(Function setOpeningTime) {
    openingTime =
        TimeOfDayExtension.timeFromStr(time.toString().substring(10, time.toString().length - 1));
    setOpeningTime(openingTime);
    if (openingTime != null) {
      _openingTimeController.text = openingTime.str();
    }
  }
}
