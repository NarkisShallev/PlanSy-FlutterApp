// import 'package:flutter/material.dart';
//
// class DetailsLineField extends StatelessWidget {
//   final String title;
//   final Function onChanged;
//   final bool isEnabled;
//   final String initialValue;
//
//
//   const DetailsLineField({this.title, @required this.onChanged, @required this.isEnabled, @required this.initialValue});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 30.0),
//       child: TextFormField(
//         initialValue: initialValue,
//         enabled: isEnabled,
//         decoration: InputDecoration(
//           labelText: title,
//         ),
//         onChanged: onChanged,
//       ),
//     );
//   }
// }