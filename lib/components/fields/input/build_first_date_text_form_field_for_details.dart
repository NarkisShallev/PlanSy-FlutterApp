import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:plansy_flutter_app/components/suffixes/custom_suffix_icon_button.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

class BuildFirstDateTextFormFieldForDetails extends StatefulWidget {
  final MaskTextInputFormatter formatter = MaskTextInputFormatter(mask: "##/##/####");
  final Function onSaved;
  final BuildContext context;
  final Function setFirstDate;
  final String lastDate;
  final bool isEnabled;
  final String initialValue;

  BuildFirstDateTextFormFieldForDetails(
      {this.onSaved,
      this.context,
      this.setFirstDate,
      this.lastDate,
      this.isEnabled,
      this.initialValue});

  @override
  _BuildFirstDateTextFormFieldForDetailsState createState() =>
      _BuildFirstDateTextFormFieldForDetailsState();
}

class _BuildFirstDateTextFormFieldForDetailsState
    extends State<BuildFirstDateTextFormFieldForDetails> {
  TextEditingController _firstDateController = TextEditingController();
  DateTime date;
  String firstDateStr = "";

  @override
  void initState() {
    super.initState();
    if (_firstDateController.text == "") {
      _firstDateController.text = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
        // ignore: deprecated_member_use
        WhitelistingTextInputFormatter(RegExp("[0-9/]")),
        widget.formatter
      ],
      enabled: widget.isEnabled,
      initialValue: !widget.isEnabled ? widget.initialValue : null,
      controller: widget.isEnabled ? _firstDateController : null,
      onSaved: widget.onSaved,
      onChanged: (value) => null,
      validator: (value) {
        if (value.isEmpty) {
          return kFromDateNullError;
        }
        if (value.isNotEmpty && !isDateValid(value, widget.lastDate)) {
          return kInvalidFromDateError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: !widget.isEnabled ? "From" : "* From",
        labelStyle: TextStyle(color: Colors.black),
        hintText: "mm/dd/yyyy",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIconButton(
          icon: Icons.calendar_today_outlined,
          color: Colors.black,
          onPressed: () async {
            await pickDate(context, widget.initialValue);
            updateVars(widget.setFirstDate);
          },
        ),
      ),
    );
  }

  bool isDateValid(String date, String lastDate) {
    RegExp calenderDate = RegExp(
        r'^[0,1]?\d{1}\/(([0-2]?\d{1})|([3][0,1]{1}))\/(([1]{1}[9]{1}[9]{1}\d{1})|([2-9]{1}\d{3}))$'); //mm/dd/yyyy
    if (!calenderDate.hasMatch(date)) {
      return false;
    }

    DateTime firstDateInDateTime;
    DateTime lastDateInDateTime;
    try {
      firstDateInDateTime =
          DateFormat('MM/dd/yyyy').parse(firstDateStr); //don't change to little mm
      lastDateInDateTime = DateFormat('MM/dd/yyyy').parse(lastDate); //don't change to little mm
      if (firstDateStr.isNotEmpty &&
          lastDate.isNotEmpty &&
          (firstDateInDateTime.compareTo(lastDateInDateTime) > 0)) {
        return false;
      }
      if (firstDateStr.isNotEmpty &&
          lastDate.isNotEmpty &&
          (firstDateInDateTime.difference(lastDateInDateTime).inDays < -14)) {
        return false;
      }
    } catch (e) {}

    return true;
  }

  Future pickDate(BuildContext context, String initialValue) async {
    try {
      DateTime initialDate =
          DateFormat('MM/dd/yyyy').parse(initialValue); //don't change to little mm
      final newDate = await showDatePicker(
        context: context,
        initialDate: date ?? initialDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
      );
      if (newDate == null) return;
      date = newDate;
    } catch (e) {}
  }

  void updateVars(Function setFirstDate) {
    try {
      firstDateStr = DateFormat('MM/dd/yyyy').format(date); //don't change to little mm
      setFirstDate(firstDateStr);
      if (firstDateStr.isNotEmpty) {
        _firstDateController.text = firstDateStr;
      }
    } catch (e) {}
  }
}
