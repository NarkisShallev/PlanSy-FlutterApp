import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/cards/attraction_card.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/screens/attractions/attraction_details_screen.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class AttractionList extends StatefulWidget {
  final int tripIndex;
  final List<Attraction> filteredAttrs;

  AttractionList({this.tripIndex, this.filteredAttrs});

  @override
  _AttractionListState createState() => _AttractionListState();
}

class _AttractionListState extends State<AttractionList> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GridView.builder(
      padding: EdgeInsets.all(getProportionateScreenWidth(8)),
      itemBuilder: (context, index) {
        final attraction = widget.filteredAttrs[index];
        return buildAttractionCardInstance(attraction, context, index);
      },
      itemCount: widget.filteredAttrs.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: getProportionateScreenWidth(5),
        mainAxisSpacing: getProportionateScreenWidth(5),
      ),
      shrinkWrap: true,
      physics: ScrollPhysics(),
    );
  }

  AttractionCard buildAttractionCardInstance(
      Attraction attraction, BuildContext context, int index) {
    return AttractionCard(
      attraction: attraction,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttractionDetailsScreen(
            attractionIndex: index,
            isAddToCartButtonVisible: true,
            isAdmin: false,
            isApproveOrRejectButtonVisible: false,
            attraction: attraction,
            isFavorite: true,
          ),
        ),
      ),
      isAddLocationFavoriteButtonsVisible: true,
      isRemoveButtonVisible: false,
    );
  }
}
