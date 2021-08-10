// import 'package:flutter/material.dart';
// import 'package:plansy_flutter_app/model/data.dart';
// import 'package:plansy_flutter_app/z_no_in_use/specific_trip_screen.dart';
// import 'package:plansy_flutter_app/z_no_in_use/trip_card.dart';
// import 'package:provider/provider.dart';
//
// class TripList extends StatefulWidget {
//   @override
//   _TripListState createState() => _TripListState();
// }
//
// class _TripListState extends State<TripList> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Data>(
//       builder: (context, tripData, child) {
//         return GridView.builder(
//           padding: const EdgeInsets.only(left: 22.0, top: 8.0, right: 8.0, bottom: 8.0),
//           itemBuilder: (context, index) {
//             final trip = tripData.trips[index];
//             return TripCard(
//               trip: trip,
//               removeFromListCallback: (){tripData.deleteTrip(trip);},
//               press: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SpecificTripScreen(
//                       tripIndex: index,
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//           itemCount: tripData.tripsCount,
//           gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//               maxCrossAxisExtent: 200,
//               crossAxisSpacing: 5.0,
//               mainAxisSpacing: 5.0),
//           shrinkWrap: true,
//           physics: ScrollPhysics(),
//         );
//       },
//     );
//   }
// }
