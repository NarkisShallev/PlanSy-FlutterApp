import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:plansy_flutter_app/components/suffixes/custom_suffix_icon_button.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

class BuildLastDateTextFormFieldForDetails extends StatefulWidget {
  final MaskTextInputFormatter formatter = MaskTextInputFormatter(mask: "##/##/####");
  final Function onSaved;
  final BuildContext context;
  final Function setLastDate;
  final bool isEnabled;
  final String initialValue;

  BuildLastDateTextFormFieldForDetails(
      {this.onSaved, this.context, this.setLastDate, this.isEnabled, this.initialValue});

  @override
  _BuildLastDateTextFormFieldForDetailsState createState() =>
      _BuildLastDateTextFormFieldForDetailsState();
}

class _BuildLastDateTextFormFieldForDetailsState
    extends State<BuildLastDateTextFormFieldForDetails> {
  TextEditingController _lastDateController = TextEditingController();
  DateTime date;
  String lastDateStr = "";

  @override
  void initState() {
    super.initState();
    if (_lastDateController.text == "") {
      _lastDateController.text = widget.initialValue;
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
      controller: widget.isEnabled ? _lastDateController : null,
      onSaved: widget.onSaved,
      onChanged: (value) => null,
      validator: (value) {
        if (value.isEmpty) {
          return kUntilDateNullError;
        }
        if (value.isNotEmpty && !isDateValid(value)) {
          return kInvalidUntilDateError;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: !widget.isEnabled ? "Until" : "* Until",
        labelStyle: TextStyle(color: Colors.black),
        hintText: "mm/dd/yyyy",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIconButton(
          icon: Icons.calendar_today_outlined,
          color: Colors.black,
          onPressed: () async {
            await pickDate(context, widget.initialValue);
            updateVars(widget.setLastDate);
          },
        ),
      ),
    );
  }

  bool isDateValid(String date) {
    RegExp calenderDate = RegExp(
        r'^[0,1]?\d{1}\/(([0-2]?\d{1})|([3][0,1]{1}))\/(([1]{1}[9]{1}[9]{1}\d{1})|([2-9]{1}\d{3}))$'); //mm/dd/yyyy
    if (!calenderDate.hasMatch(date)) {
      return false;
    }
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

  void updateVars(Function setLastDate) {
    try {
      lastDateStr = DateFormat('MM/dd/yyyy').format(date); //don't change to little mm
      print(lastDateStr);
      setLastDate(lastDateStr);
      if (lastDateStr.isNotEmpty) {
        _lastDateController.text = lastDateStr;
      }
    } catch (e) {}
  }
}
