import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class FormError extends StatelessWidget {
  const FormError({@required this.errors});

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: List.generate(errors.length, (index) => formErrorText(error: errors[index])),
    );
  }

  Row formErrorText({String error}) {
    return Row(
      children: [
        Icon(Icons.error_outline, size: getProportionateScreenWidth(20), color: Colors.red),
        SizedBox(width: getProportionateScreenWidth(10)),
        Text(error, style: TextStyle(color: Colors.red)),
      ],
    );
  }
}
