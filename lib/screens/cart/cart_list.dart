import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/trip.dart';
import 'package:plansy_flutter_app/screens/attractions/attraction_details_screen.dart';
import 'package:plansy_flutter_app/components/cards/row_attraction_card.dart';
import 'package:provider/provider.dart';

class CartList extends StatefulWidget {
  final List<Attraction> filteredAttrs;

  CartList({this.filteredAttrs});

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, attractionData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final attraction = widget.filteredAttrs[index];
            return buildRowAttractionCardInstance(attraction, context, index);
          },
          itemCount: widget.filteredAttrs.length,
          shrinkWrap: true,
          physics: ScrollPhysics(),
        );
      },
    );
  }

  RowAttractionCard buildRowAttractionCardInstance(
      Attraction attraction, BuildContext context, int index) {
    int tripIndex = Provider.of<Data>(context, listen: false).tripIndex;
    Trip trip = Provider.of<Data>(context, listen: false).trips[tripIndex];
    return RowAttractionCard(
      attraction: attraction,
      onTap: () => moveToAttractionDetailsScreen(index, attraction),
      removeFromListCallback: () =>
          Provider.of<Data>(context, listen: false).deleteAttractionFromCart(attraction, context, trip.getID()),
      isRemoveButtonVisible: true,
      isAdmin: false,
      isCart: true,
    );
  }

  void moveToAttractionDetailsScreen(int index, Attraction attraction) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttractionDetailsScreen(
            attractionIndex: index,
            isAddToCartButtonVisible: false,
            isAdmin: false,
            isApproveOrRejectButtonVisible: false,
            attraction: attraction,
          ),
        ),
      );
}
