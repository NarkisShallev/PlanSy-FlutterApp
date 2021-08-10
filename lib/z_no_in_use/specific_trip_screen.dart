// import 'package:flutter/material.dart';
// import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
// import 'package:plansy_flutter_app/z_no_in_use/options_screen.dart';
// import 'package:plansy_flutter_app/screens/todo-lists/tasks_screen.dart';
// import 'package:plansy_flutter_app/screens/schedule/schedule_screen.dart';
// import 'package:plansy_flutter_app/z_no_in_use/trip_details_screen.dart';
//
// class SpecificTripScreen extends StatelessWidget {
//   final int tripIndex;
//
//   const SpecificTripScreen({this.tripIndex});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: myAppBar(context:context, isNotification: true, isEdit: false, isSave: false, titleText: ''),
//       body: SafeArea(
//         child: OptionsScreen(
//           option1Title: "Trip's details",
//           icon1: Icon(
//             Icons.dvr,
//             color: Colors.green,
//             size: 50.0,
//           ),
//           onTapOption1: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => TripDetailsScreen(
//                   tripIndex: tripIndex,
//                 ),
//               ),
//             );
//           },
//           option2Title: "TODO List",
//           icon2: Icon(
//             Icons.view_list_rounded,
//             color: Colors.green,
//             size: 50.0,
//           ),
//           onTapOption2: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => TasksScreen()));
//           },
//           option3Title: "Schedule",
//           icon3: Icon(
//             Icons.schedule,
//             color: Colors.green,
//             size: 50.0,
//           ),
//           onTapOption3: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => ScheduleScreen(tripIndex: tripIndex,)));
//           },
//         ),
//       ),
//     );
//   }
// }
