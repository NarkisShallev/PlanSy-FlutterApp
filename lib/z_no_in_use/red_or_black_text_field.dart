// import 'package:flutter/material.dart';
//
// class RedOrBlackTextField extends StatefulWidget {
//   final bool wrong;
//   final Function press;
//   final bool obscureText;
//   final String labelText;
//   final String hintText;
//   final IconData icon;
//   final horizontalPadding;
//
//   RedOrBlackTextField(
//       {this.wrong,
//       this.press,
//       this.obscureText,
//       this.labelText,
//       this.hintText,
//       this.icon,
//       this.horizontalPadding});
//
//   @override
//   _RedOrBlackTextFieldState createState() => _RedOrBlackTextFieldState();
// }
//
// class _RedOrBlackTextFieldState extends State<RedOrBlackTextField> {
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
//         obscureText: widget.obscureText,
//         keyboardType: TextInputType.emailAddress,
//         decoration: InputDecoration(
//           enabledBorder: UnderlineInputBorder(
//             borderSide:
//                 BorderSide(color: widget.wrong ? Colors.red : Colors.black),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide:
//                 BorderSide(color: widget.wrong ? Colors.red : Colors.black),
//           ),
//           labelText: widget.labelText,
//           labelStyle: TextStyle(
//             color: widget.wrong ? Colors.red : Colors.black,
//           ),
//           hintText: widget.hintText,
//           icon: _gotIcon
//               ? Icon(
//                   widget.icon,
//                   color: widget.wrong ? Colors.red : Colors.black,
//                 )
//               : SizedBox(
//                   width: 0.0,
//                 ),
//         ),
//         onChanged: widget.press,
//       ),
//     );
//   }
// }
