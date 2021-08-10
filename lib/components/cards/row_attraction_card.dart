import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/buttons/remove_circle_button.dart';
import 'package:plansy_flutter_app/components/cards/basic/my_card.dart';
import 'package:plansy_flutter_app/components/my_attraction_priority_slider.dart';
import 'package:plansy_flutter_app/components/star_rating_with_num_of_reviews.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class RowAttractionCard extends StatefulWidget {
  final Attraction attraction;
  final Function onTap;
  final Function removeFromListCallback;
  final bool isRemoveButtonVisible;
  final bool isAdmin;
  final bool isCart;

  const RowAttractionCard({
    this.attraction,
    this.onTap,
    this.removeFromListCallback,
    @required this.isRemoveButtonVisible,
    this.isAdmin,
    this.isCart,
  });

  @override
  _RowAttractionCardState createState() => _RowAttractionCardState();
}

class _RowAttractionCardState extends State<RowAttractionCard> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      children: [
        MyCard(
          height: 108.0,
          width: double.infinity,
          leftMargin: 5,
          rightMargin: 5,
          topMargin: 10,
          bottomMargin: 0,
          color: Colors.white,
          child: InkWell(onTap: widget.onTap, child: buildRowAttractionCardContent()),
        ),
        buildRemoveIcon()
      ],
    );
  }

  Row buildRowAttractionCardContent() {
    return Row(
      children: <Widget>[
        buildAttractionImage(),
        Expanded(child: buildDescription()),
      ],
    );
  }

  Container buildAttractionImage() {
    return Container(
      width: getProportionateScreenWidth(108),
      margin: EdgeInsets.only(bottom: getProportionateScreenWidth(3)),
      decoration: BoxDecoration(
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

  Container buildDescription() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: getProportionateScreenHeight(5)),
          buildDescriptionContent(),
          buildStars(),
          Visibility(visible: widget.isCart, child: buildPrioritySlider()),
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
    return Text(widget.attraction.name, overflow: TextOverflow.ellipsis);
  }

  Text buildAttractionCategory() {
    return Text("Category: " + widget.attraction.category, overflow: TextOverflow.ellipsis);
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

  Padding buildPrioritySlider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
      child: Row(
        children: [
          Text("Priority: "),
          Expanded(child: MyAttractionPrioritySlider(attraction: widget.attraction)),
        ],
      ),
    );
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
}
