import 'package:flutter/material.dart';

class AttractionDetailTextFormField extends StatelessWidget {
  final Function onChanged;
  final String initialVal;
  final TextStyle style;
  final String suffixText;

  const AttractionDetailTextFormField(
      {@required this.onChanged, @required this.initialVal, @required this.style, this.suffixText});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        initialValue: initialVal,
        style: style,
        onChanged: onChanged,
        decoration: InputDecoration(suffixText: suffixText),
      ),
    );
  }
}
