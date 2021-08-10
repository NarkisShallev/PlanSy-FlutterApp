// import 'package:flutter/material.dart';
// import 'package:plansy_flutter_app/components/buttons/basic/default_button.dart';
// import 'package:plansy_flutter_app/model/data.dart';
// import 'package:plansy_flutter_app/model/trip.dart';
// import 'package:plansy_flutter_app/utilities/size_config.dart';
// import 'package:provider/provider.dart';
//
// class CreateTripButton extends StatelessWidget {
//   final String title;
//   final String country;
//   final String city;
//   final String duration;
//   final String firstDate;
//   final String lastDate;
//
//   const CreateTripButton(
//       {Key key, this.title, this.country, this.city, this.duration, this.firstDate, this.lastDate})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(25)),
//       child: DefaultButton(
//         text: "Create trip",
//         press: () {
//           Trip newTrip = Trip(
//             title: title,
//             country: country,
//             city: city,
//             lastDate: lastDate,
//             firstDate: firstDate,
//             state: '',
//           );
//           Provider.of<Data>(context, listen: false).addTripAndUpdateTheFireBase(context, newTrip);
//           Navigator.pop(context);
//         },
//         textColor: Colors.black,
//       ),
//     );
//   }
// }
