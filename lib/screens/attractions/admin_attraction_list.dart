import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/components/cards/attraction_card.dart';
import 'package:plansy_flutter_app/screens/attractions/attraction_details_screen.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

class AdminAttractionList extends StatefulWidget {
  final List<Attraction> filteredAttrs;

  AdminAttractionList({this.filteredAttrs});

  @override
  _AdminAttractionListState createState() => _AdminAttractionListState();
}

class _AdminAttractionListState extends State<AdminAttractionList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, attractionData, child) {
        return GridView.builder(
          padding: EdgeInsets.all(getProportionateScreenWidth(8)),
          itemBuilder: (context, index) {
            final Attraction attraction = widget.filteredAttrs[index];
            return buildAttractionCardInstance(attraction, attractionData, context, index);
          },
          itemCount: widget.filteredAttrs == null ? 0 : widget.filteredAttrs.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          shrinkWrap: true,
          physics: ScrollPhysics(),
        );
      },
    );
  }

  AttractionCard buildAttractionCardInstance(
      Attraction attraction, Data attractionData, BuildContext context, int index) {
    return AttractionCard(
      attraction: attraction,
      removeFromListCallback: () => attractionData.deleteAttraction(attraction),
      onTap: () => goToAttractionDetailsScreen(index, attraction),
      isRemoveButtonVisible: true,
      isAddLocationFavoriteButtonsVisible: false,
    );
  }

  void goToAttractionDetailsScreen(int index, Attraction attraction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttractionDetailsScreen(
          attractionIndex: index,
          isApproveOrRejectButtonVisible: false,
          isAddToCartButtonVisible: false,
          isAdmin: true,
          attraction: attraction,
          isFavorite: false,
        ),
      ),
    );
  }
}
