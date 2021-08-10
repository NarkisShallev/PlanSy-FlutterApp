// import 'package:flutter/material.dart';
// import 'package:plansy_flutter_app/z_no_in_use/detailsLineField.dart';
// import 'package:plansy_flutter_app/utilities/constants.dart';
//
// class CreateAttractionForm extends StatelessWidget {
//   final Function titleOnChanged;
//   final Function imageSrcOnChanged;
//   final Function categoryOnChanged;
//   final Function countrySrcOnChanged;
//   final Function citySrcOnChanged;
//   final Function descriptionOnChanged;
//   final Function openingTimeOnChanged;
//   final Function closingTimeOnChanged;
//
//   const CreateAttractionForm({
//     this.titleOnChanged,
//     this.imageSrcOnChanged,
//     this.categoryOnChanged,
//     this.countrySrcOnChanged,
//     this.citySrcOnChanged,
//     this.descriptionOnChanged,
//     this.openingTimeOnChanged,
//     this.closingTimeOnChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Text(
//             'Please add the attraction details:',
//             style: k18BlackStyle,
//           ),
//         ),
//         DetailsLineField(
//           title: "Title",
//           onChanged: titleOnChanged,
//           initialValue: '',
//           isEnabled: true,
//         ),
//         DetailsLineField(
//           title: "Image src",
//           onChanged: imageSrcOnChanged,
//           initialValue: '',
//           isEnabled: true,
//         ),
//         DetailsLineField(
//           title: "Category",
//           onChanged: categoryOnChanged,
//           initialValue: '',
//           isEnabled: true,
//         ),
//         DetailsLineField(
//           title: "Country",
//           onChanged: countrySrcOnChanged,
//           initialValue: '',
//           isEnabled: true,
//         ),
//         DetailsLineField(
//           title: "City",
//           onChanged: citySrcOnChanged,
//           initialValue: '',
//           isEnabled: true,
//         ),
//         DetailsLineField(
//           title: "Description",
//           onChanged: descriptionOnChanged,
//           initialValue: '',
//           isEnabled: true,
//         ),
//         DetailsLineField(
//           title: "Opening Time",
//           onChanged: openingTimeOnChanged,
//           initialValue: '',
//           isEnabled: true,
//         ),
//         DetailsLineField(
//           title: "Closing Time",
//           onChanged: closingTimeOnChanged,
//           initialValue: '',
//           isEnabled: true,
//         ),
//       ],
//     );
//   }
// }
