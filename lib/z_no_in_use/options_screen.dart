// import 'package:flutter/material.dart';
// import 'package:plansy_flutter_app/utilities/constants.dart';
//
// import '../components/cards/basic/my_card.dart';
//
// class OptionsScreen extends StatefulWidget {
//   final String option1Title;
//   final String option2Title;
//   final String option3Title;
//   final Function onTapOption1;
//   final Function onTapOption2;
//   final Function onTapOption3;
//   final Icon icon1;
//   final Icon icon2;
//   final Icon icon3;
//
//   const OptionsScreen(
//       {this.option1Title,
//       this.option2Title,
//       this.option3Title,
//       this.onTapOption1,
//       this.onTapOption2,
//       this.onTapOption3,
//       this.icon1,
//       this.icon2,
//       this.icon3});
//
//   @override
//   _OptionsScreenState createState() => _OptionsScreenState();
// }
//
// class _OptionsScreenState extends State<OptionsScreen> {
//   bool isOption1Exist = false;
//   bool isOption2Exist = false;
//   bool isOption3Exist = false;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.option1Title != null) {
//       isOption1Exist = true;
//     }
//     if (widget.option2Title != null) {
//       isOption2Exist = true;
//     }
//     if (widget.option3Title != null) {
//       isOption3Exist = true;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This size provide the total height and width of the screen
//     double size = MediaQuery.of(context).size.width;
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             isOption1Exist
//                 ? Option1(
//                     size: size,
//                     optionTitle: widget.option1Title,
//                     icon: widget.icon1,
//                     onTap: widget.onTapOption1,
//                   )
//                 : SizedBox(
//                     height: 0,
//                   ),
//             isOption2Exist
//                 ? Option2(
//                     size: size,
//                     optionTitle: widget.option2Title,
//                     icon: widget.icon2,
//                     onTap: widget.onTapOption2,
//                   )
//                 : SizedBox(
//                     height: 0,
//                   ),
//           ],
//         ),
//         isOption3Exist
//             ? Option3(
//                 optionTitle: widget.option3Title,
//                 icon: widget.icon3,
//                 onTap: widget.onTapOption3,
//               )
//             : SizedBox(
//                 height: 0,
//               ),
//       ],
//     );
//   }
// }
//
// class Option3 extends StatelessWidget {
//   final String optionTitle;
//   final Function onTap;
//   final Icon icon;
//
//   const Option3({this.optionTitle, this.onTap, this.icon});
//
//   @override
//   Widget build(BuildContext context) {
//     return MyCard(
//       width: double.infinity,
//       height: 130.0,
//       leftMargin: 25,
//       rightMargin: 25,
//       topMargin: 20,
//       bottomMargin: 5,
//       color: Colors.white,
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 icon,
//                 Text(
//                   optionTitle,
//                   textAlign: TextAlign.center,
//                   style: k13GreenStyle,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Option2 extends StatelessWidget {
//   final double size;
//   final String optionTitle;
//   final Function onTap;
//   final Icon icon;
//
//   const Option2({this.size, this.optionTitle, this.onTap, this.icon});
//
//   @override
//   Widget build(BuildContext context) {
//     return MyCard(
//       width: size / 2.5,
//       height: 130.0,
//       leftMargin: 15,
//       rightMargin: 15,
//       topMargin: 20,
//       bottomMargin: 5,
//       color: Colors.white,
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 icon,
//                 Text(
//                   optionTitle,
//                   textAlign: TextAlign.center,
//                   style: k13GreenStyle,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Option1 extends StatelessWidget {
//   final double size;
//   final String optionTitle;
//   final Function onTap;
//   final Icon icon;
//
//   const Option1({this.size, this.optionTitle, this.onTap, this.icon});
//
//   @override
//   Widget build(BuildContext context) {
//     return MyCard(
//       width: size / 2.5,
//       height: 130.0,
//       leftMargin: 15,
//       rightMargin: 15,
//       topMargin: 20,
//       bottomMargin: 5,
//       color: Colors.white,
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 icon,
//                 Text(
//                   optionTitle,
//                   textAlign: TextAlign.center,
//                   style: k13GreenStyle,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
