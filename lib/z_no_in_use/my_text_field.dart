// import 'package:flutter/material.dart';
//
// class MyTextField extends StatefulWidget {
//   final Function press;
//   final String labelText;
//   final String hintText;
//   final IconData icon;
//   final horizontalPadding;
//
//   MyTextField(
//       {this.press,
//         this.labelText,
//         this.hintText,
//         this.icon,
//         this.horizontalPadding});
//
//   @override
//   _MyTextField createState() => _MyTextField();
// }
//
// class _MyTextField extends State<MyTextField> {
//   bool _gotIcon = false;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.icon != null) {
//       _gotIcon = true;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
//       child: TextField(
//         keyboardType: TextInputType.emailAddress,
//         decoration: InputDecoration(
//           enabledBorder: UnderlineInputBorder(
//             borderSide:
//             BorderSide(color: Colors.black),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide:
//             BorderSide(color: Colors.black),
//           ),
//           labelText: widget.labelText,
//           labelStyle: TextStyle(
//             color: Colors.black,
//           ),
//           hintText: widget.hintText,
//           icon: _gotIcon
//               ? Icon(
//             widget.icon,
//             color: Colors.black,
//           )
//               : SizedBox(
//             width: 0.0,
//           ),
//         ),
//         onChanged: widget.press,
//       ),
//     );
//   }
// }
