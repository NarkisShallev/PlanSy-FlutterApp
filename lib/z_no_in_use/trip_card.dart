// import 'package:flutter/material.dart';
// import 'package:plansy_flutter_app/components/buttons/remove_circle_button.dart';
// import 'package:plansy_flutter_app/components/cards/basic/my_card.dart';
// import 'package:plansy_flutter_app/model/data.dart';
// import 'package:plansy_flutter_app/model/trip.dart';
// import 'package:plansy_flutter_app/utilities/constants.dart';
// import 'package:provider/provider.dart';
//
// class TripCard extends StatefulWidget {
//   final Trip trip;
//   final Function removeFromListCallback;
//   final Function press;
//
//   const TripCard({this.trip, this.removeFromListCallback, this.press});
//
//   @override
//   _TripCardState createState() => _TripCardState();
// }
//
// class _TripCardState extends State<TripCard> {
//   int tripsImageNum;
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   // tripsImageNum =
//   //     Provider.of<Data>(context, listen: false).tripBackgroundImageNum;
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     // This size provide the total height and width of the screen
//     double size = MediaQuery.of(context).size.width;
//     return Stack(
//       children: [
//         MyCard(
//           width: size / 2.5,
//           leftMargin: 5,
//           rightMargin: 5,
//           topMargin: 5,
//           bottomMargin: 5,
//           color: Colors.white,
//           //image: "trips$tripsImageNum.png",
//           child: InkWell(
//             onTap: widget.press,
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.emoji_transportation,
//                       color: Colors.green,
//                       size: 60.0,
//                     ),
//                     Text(
//                       widget.trip.title,
//                       textAlign: TextAlign.center,
//                       style: k13GreenStyle,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         // icons
//         Provider.of<Data>(context, listen: false).isHomeEditEnabled
//             ? Positioned(
//                 right: 15.0,
//                 top: 5.0,
//                 child: Row(
//                   children: [
//                     RemoveCircleButton(
//                       removeFromListCallback: widget.removeFromListCallback,
//                     ),
//                   ],
//                 ),
//               )
//             : SizedBox(
//                 width: 0.0,
//               ),
//       ],
//     );
//   }
// }
