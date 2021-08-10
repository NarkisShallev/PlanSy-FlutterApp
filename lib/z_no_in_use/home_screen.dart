// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
// import 'package:plansy_flutter_app/z_no_in_use/create_screen_floating_action_button.dart';
// import 'package:plansy_flutter_app/model/data.dart';
// import 'package:plansy_flutter_app/z_no_in_use/trip_list.dart';
// import 'package:plansy_flutter_app/utilities/constants.dart';
// import 'package:provider/provider.dart';
//
// class HomeScreen extends StatefulWidget {
//   final _auth = FirebaseAuth.instance;
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   User _loggedInUser;
//   String partOfDay = '';
//   bool isEmpty;
//   bool iEditEnabled;
//
//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//     int hour = DateTime.now().hour;
//     partOfDay = convertHourToPartOfDay(hour);
//     print(hour);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     //Provider.of<Data>(context, listen: true).checkIfTripsIsEmpty();
//     //isEmpty = Provider.of<Data>(context, listen: true).isTripsEmpty;
//     iEditEnabled = Provider.of<Data>(context, listen: false).isHomeEditEnabled;
//     return Scaffold(
//       appBar: iEditEnabled
//           ? myAppBar(
//               context: context,
//               isNotification: true,
//               isEdit: false,
//               isSave: true,
//               onPressedSave: () {
//                 setState(
//                   () {
//                     Provider.of<Data>(context, listen: false)
//                         .isHomeEditEnabled = false;
//                   },
//                 );
//               }, titleText: '',
//             )
//           : myAppBar(
//               context: context,
//               isNotification: true,
//               isEdit: true,
//               isSave: false,
//               onPressedEdit: () {
//                 setState(
//                   () {
//                     Provider.of<Data>(context, listen: false)
//                         .isHomeEditEnabled = true;
//                   },
//                 );
//               }, titleText: '',
//             ),
//       //drawer: HomeDrawer(auth: widget._auth, email: _loggedInUser.email),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Container(
//               width: size.width,
//               height: size.height,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Column(
//                         children: [
//                           Text(
//                             'Good $partOfDay!',
//                             style: kTitleStyle,
//                           ),
//                           Text(
//                             'What do you want to do today?',
//                             style: kTitleStyle,
//                           ),
//                         ],
//                       ),
//                     ),
//                     isEmpty
//                         ? Image(
//                             image: AssetImage('images/empty_trips.png'),
//                             fit: BoxFit.fitWidth,
//                             width: double.infinity,
//                           )
//                         : TripList(),
//                   ],
//                 ),
//               ),
//             ),
//             CreateScreenFloatingActionButton(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void getCurrentUser() {
//     try {
//       final user = widget._auth.currentUser;
//       if (user != null) {
//         _loggedInUser = user;
//       }
//     } catch (e) {
//       print(e.code);
//     }
//   }
//
//   String convertHourToPartOfDay(int hour) {
//     if ((hour >= 5) & (hour < 12)) {
//       return 'morning';
//     } else if ((hour >= 12) & (hour < 17)) {
//       return 'afternoon';
//     } else if ((hour >= 17) & (hour < 21)) {
//       return 'evening';
//     } else {
//       return 'night';
//     }
//   }
// }
