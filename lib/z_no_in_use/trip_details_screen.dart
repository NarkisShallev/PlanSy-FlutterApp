// import 'package:flutter/material.dart';
// import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
// import 'package:plansy_flutter_app/z_no_in_use/detailsLineField.dart';
// import 'package:plansy_flutter_app/model/data.dart';
// import 'package:plansy_flutter_app/model/trip.dart';
// import 'package:plansy_flutter_app/utilities/constants.dart';
// import 'package:provider/provider.dart';
//
// class TripDetailsScreen extends StatefulWidget {
//   final int tripIndex;
//
//   const TripDetailsScreen({@required this.tripIndex});
//
//   @override
//   _TripDetailsScreenState createState() => _TripDetailsScreenState();
// }
//
// class _TripDetailsScreenState extends State<TripDetailsScreen> {
//   bool isEnabled = false;
//   Trip trip;
//   String title;
//   String country;
//   String city;
//   String daysNum;
//
//   @override
//   void initState() {
//     super.initState();
//     trip = Provider.of<Data>(context, listen: false).trips[widget.tripIndex];
//     title = trip.title;
//     country = trip.country;
//     city = trip.city;
//     daysNum = trip.duration;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: isEnabled
//           ? myAppBar(
//               context: context,
//               isNotification: true,
//               isEdit: false,
//               isSave: true,
//               onPressedSave: () {
//                 setState(() {
//                   isEnabled = false;
//                 });
//                 Trip updatedTrip = Trip(
//                     title: title,
//                     country: country,
//                     city: city,
//                     duration: daysNum);
//                 Provider.of<Data>(context, listen: false)
//                     .updateTrip(widget.tripIndex, updatedTrip);
//               },
//               titleText: '')
//           : myAppBar(
//               context: context,
//               isNotification: true,
//               isEdit: true,
//               isSave: false,
//               onPressedEdit: () {
//                 setState(
//                   () {
//                     isEnabled = true;
//                   },
//                 );
//               },
//               titleText: '',
//             ),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Container(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Text(
//                     "Your trip's details:",
//                     style: kTitleStyle,
//                   ),
//                 ),
//                 DetailsLineField(
//                   title: "Title",
//                   onChanged: (value) {
//                     title = value;
//                   },
//                   initialValue: trip.title,
//                   isEnabled: isEnabled,
//                 ),
//                 DetailsLineField(
//                   title: "Country",
//                   onChanged: (value) {
//                     country = value;
//                   },
//                   initialValue: trip.country,
//                   isEnabled: isEnabled,
//                 ),
//                 DetailsLineField(
//                   title: "City",
//                   onChanged: (value) {
//                     city = value;
//                   },
//                   initialValue: trip.city,
//                   isEnabled: isEnabled,
//                 ),
//                 DetailsLineField(
//                   title: "Duration",
//                   onChanged: (value) {
//                     daysNum = value;
//                   },
//                   initialValue: trip.duration,
//                   isEnabled: isEnabled,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
