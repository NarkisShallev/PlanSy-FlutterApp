// import 'package:flutter/material.dart';
// import 'package:plansy_flutter_app/components/buttons/basic/default_button.dart';
// import 'package:plansy_flutter_app/model/attraction.dart';
// import 'package:plansy_flutter_app/model/data.dart';
// import 'package:plansy_flutter_app/utilities/size_config.dart';
// import 'package:provider/provider.dart';
//
// class AddButton extends StatelessWidget {
//   final String title;
//   final String imageSrc;
//   final String category;
//   final String country;
//   final String description;
//   final TimeOfDay openingTime;
//   final TimeOfDay closingTime;
//   final String rushHours;
//   final String webSite;
//   final String payment;
//   final String isNeedToBuyTicketsInAdvance;
//   final String suitableFor;
//   final String recommendations;
//   final String numOfReviews;
//   final String rating;
//   final String suitableWeather;
//   final TimeOfDay duration;
//
//   const AddButton({
//     @required this.title,
//     @required this.imageSrc,
//     @required this.category,
//     @required this.country,
//     @required this.description,
//     @required this.openingTime,
//     @required this.closingTime,
//     @required this.rushHours,
//     @required this.webSite,
//     @required this.payment,
//     @required this.isNeedToBuyTicketsInAdvance,
//     @required this.suitableFor,
//     @required this.recommendations,
//     @required this.numOfReviews,
//     @required this.rating,
//     @required this.suitableWeather,
//     @required this.duration,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Padding(
//       padding:
//           EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(25)),
//       child: DefaultButton(
//         text: "Add",
//         press: () {
//           Attraction newAttraction = Attraction(
//             status: 1,
//             name: title,
//             imageSrc: imageSrc,
//             category: category,
//             address: "location",
//             country: country,
//             description: description,
//             openingTime: openingTime,
//             closingTime: closingTime,
//             webSite: webSite,
//             pricing: payment,
//             isNeedToBuyTickets: isNeedToBuyTicketsInAdvance,
//             suitableFor: suitableFor,
//             recommendations: recommendations,
//             numOfReviews: numOfReviews,
//             rating: rating,
//             suitableSeason: suitableWeather,
//             duration: duration,
//           );
//           Provider.of<Data>(context, listen: false)
//               .addAttraction(newAttraction);
//           Navigator.pop(context);
//         },
//         textColor: Colors.black,
//       ),
//     );
//   }
// }
