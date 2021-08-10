import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

class NextButton extends StatelessWidget {
  final Function onPressed;

  const NextButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: Text("NEXT >", style: TextStyle(color: kPrimaryColor)),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
