import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class StarRatingWithNumOfReviews extends StatelessWidget {
  final int numOfReviews;
  final double rating;
  final double starsSize;
  final MainAxisAlignment alignment;
  final bool isReadOnly;
  final Function onRated;

  const StarRatingWithNumOfReviews({
    this.numOfReviews,
    this.rating,
    this.starsSize,
    this.alignment,
    this.isReadOnly,
    this.onRated,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Row(
      mainAxisAlignment: alignment,
      children: [
        SmoothStarRating(
          size: starsSize,
          borderColor: Color(0xFFFFC61F),
          color: Color(0xFFFFC61F),
          rating: rating,
          isReadOnly: isReadOnly,
          onRated: onRated,
        ),
        SizedBox(width: getProportionateScreenWidth(10)),
        Text("($numOfReviews)", style: TextStyle(fontSize: getProportionateScreenWidth(10))),
      ],
    );
  }
}
