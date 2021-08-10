// import 'package:flutter/material.dart';
// import 'package:plansy_flutter_app/utilities/constants.dart';
//
// class MainButton extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final Function press;
//   final double height;
//   final double width;
//
//   const MainButton({this.icon, this.title, this.press, this.height, this.width});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height ?? 50,
//       width: width ?? 250,
//       decoration: BoxDecoration(
//           color: kPrimaryColor),
//       // ignore: deprecated_member_use
//       child: FlatButton(
//         onPressed: press,
//         child: icon == null
//             ? Text(
//                 title,
//                 style: TextStyle(color: Colors.white, fontSize: 25),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.add_location_alt,
//                     color: Colors.white,
//                   ),
//                   SizedBox(
//                     width: 10.0,
//                   ),
//                   Text(
//                     title,
//                     style: TextStyle(color: Colors.white, fontSize: 25),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }
