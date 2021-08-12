import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/cards/row_attraction_card.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/request.dart';
import 'package:plansy_flutter_app/screens/attractions/attraction_details_screen.dart';
import 'package:plansy_flutter_app/screens/requests/update_attraction_details_screen.dart';
import 'package:provider/provider.dart';

class AdminRequestsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, attractionData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final request = attractionData.requests[index];
            return buildRowAttractionCardInstance(request, context);
          },
          itemCount: attractionData.requestsCount,
          shrinkWrap: true,
          physics: ScrollPhysics(),
        );
      },
    );
  }

  RowAttractionCard buildRowAttractionCardInstance(Request request, BuildContext context) {
    return RowAttractionCard(
      attraction: request.updatedAttraction,
      onTap: () {
        if (request.updatedAttraction.status == 2) {
          moveToUpdateAttractionDetailsScreen(context, request);
        } else {
          moveToAttractionDetailsScreen(context, request);
        }
      },
      isRemoveButtonVisible: false,
      isAdmin: true,
      isCart: false,
    );
  }

  void moveToUpdateAttractionDetailsScreen(BuildContext context, Request request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateAttractionDetailsScreen(
          request: request,
          isApproveOrRejectButtonVisible: true,
          isAdmin: true,
          isAddToCartButtonVisible: false,
        ),
      ),
    );
  }

  void moveToAttractionDetailsScreen(BuildContext context, Request request) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttractionDetailsScreen(
            attractionIndex: null,
            attraction: request.updatedAttraction,
            isApproveOrRejectButtonVisible: true,
            isAdmin: true,
            isAddToCartButtonVisible: false,
            isFavorite: false,
          ),
        ),
      );
}
