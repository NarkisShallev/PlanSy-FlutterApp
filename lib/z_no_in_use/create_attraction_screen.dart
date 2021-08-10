// import 'package:flutter/material.dart';
// import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
// import 'package:plansy_flutter_app/z_no_in_use/add_button.dart';
// import 'package:plansy_flutter_app/z_no_in_use/send_to_confirm_button.dart';
// import 'package:plansy_flutter_app/z_no_in_use/create_attraction_form.dart';
// import 'package:plansy_flutter_app/utilities/size_config.dart';
//
// class CreateAttractionScreen extends StatefulWidget {
//   final bool isAdmin;
//
//   const CreateAttractionScreen({@required this.isAdmin});
//
//   @override
//   _CreateAttractionScreenState createState() => _CreateAttractionScreenState();
// }
//
// class _CreateAttractionScreenState extends State<CreateAttractionScreen> {
//   String title;
//   String imageSrc;
//   String category;
//   String country;
//   String description;
//   TimeOfDay openingTime;
//   TimeOfDay closingTime;
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return Scaffold(
//       appBar: myAppBar(
//           context: context,
//           isNotification: true,
//           isEdit: false,
//           isSave: false,
//           titleText: '',
//           iconsColor: Colors.black),
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Column(
//             children: [
//               CreateAttractionForm(
//                 titleOnChanged: (value) {
//                   setState(() {
//                     title = value;
//                   });
//                 },
//                 imageSrcOnChanged: (value) {
//                   setState(() {
//                     imageSrc = value;
//                   });
//                 },
//                 categoryOnChanged: (value) {
//                   setState(() {
//                     category = value;
//                   });
//                 },
//                 countrySrcOnChanged: (value) {
//                   setState(() {
//                     country = value;
//                   });
//                 },
//                 descriptionOnChanged: (value) {
//                   setState(() {
//                     description = value;
//                   });
//                 },
//                 openingTimeOnChanged: (value) {
//                   setState(() {
//                     openingTime = value;
//                   });
//                 },
//                 closingTimeOnChanged: (value) {
//                   setState(() {
//                     closingTime = value;
//                   });
//                 },
//               ),
//               SizedBox(
//                 height: 30.0,
//               ),
//               Visibility(
//                 visible: !widget.isAdmin,
//                 child: SendToConfirmButton(
//                   title: title,
//                   imageSrc: imageSrc,
//                   category: category,
//                   country: country,
//                   description: description,
//                   openingTime: openingTime,
//                   closingTime: closingTime,
//                   suitableFor: '',
//                   payment: '',
//                   numOfReviews: '',
//                   webSite: '',
//                   rushHours: '',
//                   isNeedToBuyTicketsInAdvance: '',
//                   suitableWeather: '',
//                   recommendations: '',
//                   duration: TimeOfDay(hour: 0, minute: 0),
//                   rating: '',
//                 ),
//               ),
//               Visibility(
//                 visible: widget.isAdmin,
//                 child: AddButton(
//                   title: title,
//                   imageSrc: imageSrc,
//                   category: category,
//                   country: country,
//                   description: description,
//                   openingTime: openingTime,
//                   closingTime: closingTime,
//                   suitableFor: '',
//                   duration: TimeOfDay(hour: 0, minute: 0),
//                   recommendations: '',
//                   suitableWeather: '',
//                   payment: '',
//                   isNeedToBuyTicketsInAdvance: '',
//                   numOfReviews: '',
//                   rating: '',
//                   webSite: '',
//                   rushHours: '',
//                 ),
//               ),
//               SizedBox(height: getProportionateScreenHeight(15)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
