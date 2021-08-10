import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:plansy_flutter_app/components/suffixes/custom_suffix_icon_button.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

class BuildDurationTextFormFieldForDetails extends StatefulWidget {
  final MaskTextInputFormatter formatter = MaskTextInputFormatter(mask: "##:##");
  final Function onSaved;
  final BuildContext context;
  final Function setDuration;
  final bool isEnabled;
  final String initialValue;
  final bool isUpdate;

  BuildDurationTextFormFieldForDetails({
    this.onSaved,
    this.context,
    this.setDuration,
    this.isEnabled,
    this.initialValue,
    this.isUpdate,
  });

  @override
  _BuildDurationTextFormFieldForDetailsState createState() =>
      _BuildDurationTextFormFieldForDetailsState();
}

class _BuildDurationTextFormFieldForDetailsState
    extends State<BuildDurationTextFormFieldForDetails> {
  TextEditingController _durationController = TextEditingController();
  TimeOfDay duration = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay time;

  @override
  void initState() {
    super.initState();
    if (_durationController.text == "") {
      _durationController.text = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: widget.isUpdate ? k12BlackStyle : k13BlackStyle,
      inputFormatters: [
        LengthLimitingTextInputFormatter(5),
        // ignore: deprecated_member_use
        WhitelistingTextInputFormatter(RegExp("[0-9:]")),
        widget.formatter
      ],
      controller: widget.isEnabled ? _durationController : null,
      initialValue: !widget.isEnabled ? widget.initialValue : null,
      enabled: widget.isEnabled,
      onSaved: widget.onSaved,
      onChanged: (value) => null,
      validator: (value) {
        if (value.isEmpty) {
          return kDurationNullError;
        }
        if (value.isNotEmpty && !isTimeValid(value)) {
          return kInvalidDurationError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: widget.isUpdate ? "" : "* Duration",
        labelStyle: TextStyle(color: Colors.black),
        hintText: "hh:mm",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIconButton(
          icon: Icons.access_time,
          color: Colors.black,
          onPressed: () async {
            await pickTime24Hour(context);
            updateVars(widget.setDuration);
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

    time = newTime;
  }

  void updateVars(Function setDuration) {
    duration =
        TimeOfDayExtension.timeFromStr(time.toString().substring(10, time.toString().length - 1));
    setDuration(duration);
    if (duration != null) {
      _durationController.text = duration.str();
    }
  }
}
