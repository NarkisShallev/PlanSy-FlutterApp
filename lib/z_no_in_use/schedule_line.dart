// import 'package:flutter/material.dart';
// import 'package:plansy_flutter_app/utilities/size_config.dart';
//
// class ScheduleLine extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.only(
//           top: getProportionateScreenWidth(5),
//           bottom: getProportionateScreenWidth(5)),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             offset: Offset(0, 4),
//             blurRadius: getProportionateScreenWidth(20),
//             color: Color(0xFFB0CCE1).withOpacity(0.32),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {},
//           child: Padding(
//             padding: EdgeInsets.all(getProportionateScreenWidth(20)),
//             child: Column(
//               children: <Widget>[
//                 Text('title'),
//                 SizedBox(height: getProportionateScreenHeight(10)),
//                 Text(
//                   "ADD TEXT HERE",
//                   style: TextStyle(fontSize: getProportionateScreenWidth(12)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
