// import 'package:flutter/material.dart';
// import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
// import 'package:plansy_flutter_app/z_no_in_use/create_trip_button.dart';
// import 'package:plansy_flutter_app/z_no_in_use/detailsLineField.dart';
// import 'package:plansy_flutter_app/utilities/constants.dart';
//
// class CreateTripScreen extends StatefulWidget {
//   @override
//   _CreateTripScreenState createState() => _CreateTripScreenState();
// }
//
// class _CreateTripScreenState extends State<CreateTripScreen> {
//   String title;
//   String country;
//   String city;
//   String duration;
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: myAppBar(
//           context: context,
//           isNotification: true,
//           isEdit: false,
//           isSave: false,
//           titleText: '',
//           iconsColor: null),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Text(
//                   'Add your trip details:',
//                   style: k18BlackStyle,
//                 ),
//               ),
//               DetailsLineField(
//                 title: "Title",
//                 onChanged: (value) {
//                   title = value;
//                 },
//                 initialValue: '',
//                 isEnabled: true,
//               ),
//               DetailsLineField(
//                 title: "Country",
//                 onChanged: (value) {
//                   country = value;
//                 },
//                 initialValue: '',
//                 isEnabled: true,
//               ),
//               DetailsLineField(
//                 title: "City",
//                 onChanged: (value) {
//                   city = value;
//                 },
//                 initialValue: '',
//                 isEnabled: true,
//               ),
//               DetailsLineField(
//                 title: "Duration",
//                 onChanged: (value) {
//                   duration = value;
//                 },
//                 initialValue: '',
//                 isEnabled: true,
//               ),
//               SizedBox(
//                 height: size.height / 4,
//               ),
//               CreateTripButton(
//                 title: title,
//                 country: country,
//                 city: city,
//                 duration: duration,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
