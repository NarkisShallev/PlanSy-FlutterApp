// import 'package:flutter/material.dart';
// import 'package:plansy_flutter_app/model/data.dart';
// import 'package:plansy_flutter_app/screens/attractions/attraction_details_screen.dart';
// import 'package:plansy_flutter_app/components/cards/row_attraction_card.dart';
// import 'package:provider/provider.dart';
//
// class ListViewScreen extends StatefulWidget {
//   @override
//   _ListViewScreenState createState() => _ListViewScreenState();
// }
//
// class _ListViewScreenState extends State<ListViewScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Data>(
//       builder: (context, attractionData, child) {
//         attractionData.setID();
//         return ListView.builder(
//           padding: const EdgeInsets.all(8.0),
//           itemBuilder: (context, index) {
//             final attraction = attractionData.attractions[index];
//             return RowAttractionCard(
//               attraction: attraction,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AttractionDetailsScreen(
//                       attractionIndex: index,
//                       isApproveOrRejectButtonVisible: null,
//                       isAdmin: null,
//                       isAddToCartButtonVisible: null,
//                     ),
//                   ),
//                 );
//               },
//               isRemoveButtonVisible: null,
//             );
//           },
//           itemCount: attractionData.attractionsCount,
//           shrinkWrap: true,
//           physics: ScrollPhysics(),
//         );
//       },
//     );
//   }
// }
