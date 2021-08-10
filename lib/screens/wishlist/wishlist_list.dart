import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/trip.dart';
import 'package:plansy_flutter_app/screens/attractions/attraction_details_screen.dart';
import 'package:plansy_flutter_app/components/cards/row_attraction_card.dart';
import 'package:provider/provider.dart';

class WishListList extends StatefulWidget {
  final List<Attraction> filteredAttrs;

  WishListList({this.filteredAttrs});

  @override
  _WishListListState createState() => _WishListListState();
}

class _WishListListState extends State<WishListList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, attractionWishListData, child) {
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
    int tripId = Provider.of<Data>(context, listen: false).tripIndex;
    Trip trip = Provider.of<Data>(context, listen: false).trips[tripId];
    return RowAttractionCard(
      attraction: attraction,
      onTap: () => moveToAttractionDetailsScreen(index, attraction),
      removeFromListCallback: () =>
          Provider.of<Data>(context, listen: false).deleteAttractionFromWishList(attraction, context, trip.getID()),
      isRemoveButtonVisible: true,
      isAdmin: false,
      isCart: false,
    );
  }

  void moveToAttractionDetailsScreen(int index, Attraction attraction) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttractionDetailsScreen(
            attractionIndex: index,
            isAddToCartButtonVisible: true,
            isAdmin: false,
            isApproveOrRejectButtonVisible: false,
            attraction: attraction,
          ),
        ),
      );
}
