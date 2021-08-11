import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/buttons/remove_circle_button.dart';
import 'package:plansy_flutter_app/components/cards/basic/my_card.dart';
import 'package:plansy_flutter_app/components/dialogs/show_add_to_trip_dialog.dart';
import 'package:plansy_flutter_app/components/star_rating_with_num_of_reviews.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/trip.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

class AttractionCard extends StatefulWidget {
  final Attraction attraction;
  final Function onTap;
  final Function removeFromListCallback;
  final bool isRemoveButtonVisible;
  final bool isAddLocationFavoriteButtonsVisible;

  const AttractionCard({
    this.attraction,
    this.onTap,
    this.removeFromListCallback,
    @required this.isRemoveButtonVisible,
    @required this.isAddLocationFavoriteButtonsVisible,
  });

  @override
  _AttractionCardState createState() => _AttractionCardState();
}

class _AttractionCardState extends State<AttractionCard> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MyCard(
      leftMargin: getProportionateScreenWidth(5),
      rightMargin: getProportionateScreenWidth(5),
      topMargin: getProportionateScreenWidth(20),
      bottomMargin: getProportionateScreenWidth(5),
      color: Colors.white,
      child: InkWell(onTap: widget.onTap, child: buildAttractionCardContent()),
    );
  }

  Column buildAttractionCardContent() {
    return Column(
      children: <Widget>[
        Stack(
          children: [
            buildAttractionImage(),
            buildAddLocationIcon(),
            buildFavoriteIcon(),
            buildRemoveIcon(),
          ],
        ),
        buildDescription(),
      ],
    );
  } 

  Container buildAttractionImage() {
    return Container(
      height: getProportionateScreenWidth(100),
      margin: EdgeInsets.only(bottom: getProportionateScreenWidth(5)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: kPrimaryColor.withOpacity(0.13),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: widget.attraction.imageSrc == "default_image.png"
              ? AssetImage("images/" + widget.attraction.imageSrc)
              : NetworkImage(widget.attraction.imageSrc),
        ),
      ),
    );
  }

  Visibility buildAddLocationIcon() {
    return Visibility(
      visible: widget.isAddLocationFavoriteButtonsVisible,
      child: Positioned(
        right: getProportionateScreenWidth(30),
        top: getProportionateScreenWidth(-5),
        child: buildAddLocationIconButton(),
      ),
    );
  }

  IconButton buildAddLocationIconButton() {
    bool isPressed = Provider.of<Data>(context, listen: false).cartContains(widget.attraction);
    return IconButton(
      onPressed: () => _addToCartWhenPress(),
      icon: isPressed
          ? Icon(Icons.add_location, color: Colors.white.withOpacity(0.8))
          : Icon(Icons.add_location_alt, color: Colors.white.withOpacity(0.8)),
    );
  }

  void _addToCartWhenPress() {
    int tripIndex = Provider.of<Data>(context, listen: false).tripIndex;
    Trip trip = Provider.of<Data>(context, listen: false).trips[tripIndex];

    bool isPressed = Provider.of<Data>(context, listen: false).cartContains(widget.attraction);
    setState(() {
      if (isPressed) {
        showAddToTripDialog(context, true);
        //Provider.of<Data>(context, listen: false).deleteAttractionFromCart(widget.attraction);
      } else {
        Provider.of<Data>(context, listen: false).addAttractionToCart(widget.attraction, context, trip.getID());
        showAddToTripDialog(context, false);
      }
    });
  }

  Visibility buildFavoriteIcon() {
    return Visibility(
      visible: widget.isAddLocationFavoriteButtonsVisible,
      child: Positioned(
        right: getProportionateScreenWidth(-5),
        top: getProportionateScreenWidth(-5),
        child: buildFavoriteIconButton(),
      ),
    );
  }

  IconButton buildFavoriteIconButton() {
    bool isFavorite = Provider.of<Data>(context, listen: false).wishListContains(widget.attraction);
    return IconButton(
      onPressed: () {
        _changeColorFavoriteWhenPress();
      },
      icon: isFavorite
          ? Icon(
              Icons.favorite,
              color: isFavorite ? Colors.red : Colors.white.withOpacity(0.8),
            )
          : Icon(
              Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white.withOpacity(0.8),
            ),
    );
  }

  void _changeColorFavoriteWhenPress() {
    int tripId = Provider.of<Data>(context, listen: false).tripIndex;
    Trip trip = Provider.of<Data>(context, listen: false).trips[tripId];
    bool isPressed = Provider.of<Data>(context, listen: false).wishListContains(widget.attraction);
    if (isPressed) {
      Provider.of<Data>(context, listen: false).deleteAttractionFromWishList(widget.attraction, context, trip.getID());
    } else {
      Provider.of<Data>(context, listen: false).addAttractionToWishList(widget.attraction, context, trip.getID());
    }
  }

  Visibility buildRemoveIcon() {
    return Visibility(
      visible: widget.isRemoveButtonVisible,
      child: Positioned(
        right: getProportionateScreenWidth(-5),
        top: getProportionateScreenWidth(-5),
        child: Row(
          children: [
            RemoveCircleButton(removeFromListCallback: widget.removeFromListCallback),
          ],
        ),
      ),
    );
  }

  Container buildDescription() {
    return Container(
      child: Column(
        children: [
          buildDescriptionContent(),
          buildStars(),
        ],
      ),
    );
  }

  Column buildDescriptionContent() {
    return Column(
      children: [
        buildAttractionName(),
        buildAttractionCategory(),
      ],
    );
  }

  Text buildAttractionName() {
    return Text(
      widget.attraction.name,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: getProportionateScreenWidth(10)),
    );
  }

  Text buildAttractionCategory() {
    return Text(
      "Category: " + widget.attraction.category,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: getProportionateScreenWidth(10)),
    );
  }

  StarRatingWithNumOfReviews buildStars() {
    return StarRatingWithNumOfReviews(
      numOfReviews: int.parse(widget.attraction.numOfReviews),
      rating: double.parse(widget.attraction.rating),
      starsSize: getProportionateScreenWidth(12),
      alignment: MainAxisAlignment.center,
      isReadOnly: true,
    );
  }
}
