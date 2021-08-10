import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:plansy_flutter_app/components/suffixes/custom_suffix_icon_button.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

class BuildFirstDateTextFormFieldForCreate extends StatefulWidget {
  final MaskTextInputFormatter formatter = MaskTextInputFormatter(mask: "##/##/####");
  final Function onSaved;
  final BuildContext context;
  final Function setFirstDate;
  final String lastDate;

  BuildFirstDateTextFormFieldForCreate(
      {this.onSaved, this.context, this.setFirstDate, this.lastDate});

  @override
  _BuildFirstDateTextFormFieldForCreateState createState() =>
      _BuildFirstDateTextFormFieldForCreateState();
}

class _BuildFirstDateTextFormFieldForCreateState
    extends State<BuildFirstDateTextFormFieldForCreate> {
  TextEditingController _firstDateController = TextEditingController();
  DateTime date;
  String firstDateStr = "";

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
        // ignore: deprecated_member_use
        WhitelistingTextInputFormatter(RegExp("[0-9/]")),
        widget.formatter
      ],
      controller: _firstDateController,
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
        labelText: "* From",
        labelStyle: TextStyle(color: Colors.black),
        hintText: "mm/dd/yyyy",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIconButton(
          icon: Icons.calendar_today_outlined,
          color: Colors.black,
          onPressed: () async {
            await pickDate(context);
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

  Future pickDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate == null) return;
    date = newDate;
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
