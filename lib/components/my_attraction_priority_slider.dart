import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/FireBase/FireBaseSingelton.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class MyAttractionPrioritySlider extends StatefulWidget {
  final Attraction attraction;

  const MyAttractionPrioritySlider({this.attraction});

  @override
  State<MyAttractionPrioritySlider> createState() => _MyAttractionPrioritySliderState();
}

class _MyAttractionPrioritySliderState extends State<MyAttractionPrioritySlider> {
  double _currentSliderValue = 1;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Slider(
          value: _currentSliderValue,
          min: 1,
          max: 10,
          divisions: 10,
          label: _currentSliderValue.round().toString(),
          onChanged: onSliderValueChanged,
          activeColor: kPrimaryColor,
          inactiveColor: Colors.black45,
        ),
      ],
    );
  }

  void onSliderValueChanged(double value) {
    Map<String, dynamic> changes = {}; // map between field and change, e.g: "location", "value".

    setState(() => _currentSliderValue = value);

    //todo: add to changes
    // changes["Priority"] = value;
    createUpdatedNumOfReviewsAndRatingAttraction(value.toInt());
    FireBaseSingleton().changeAttraction(widget.attraction.getID(), changes);
  }

  Attraction createUpdatedNumOfReviewsAndRatingAttraction(int newPriority) {
    Attraction updated = Attraction(
        status: 2,
        priority: newPriority,
        category: widget.attraction.category,
        address: widget.attraction.address,
        openingTime: widget.attraction.openingTime,
        closingTime: widget.attraction.closingTime,
        numOfReviews: widget.attraction.numOfReviews,
        description: widget.attraction.description,
        country: widget.attraction.country,
        duration: widget.attraction.duration,
        isNeedToBuyTickets: widget.attraction.isNeedToBuyTickets,
        suitableFor: widget.attraction.suitableFor,
        suitableSeason: widget.attraction.suitableSeason,
        recommendations: widget.attraction.recommendations,
        pricing: widget.attraction.pricing,
        imageSrc: widget.attraction.imageSrc,
        name: widget.attraction.name,
        webSite: widget.attraction.webSite,
        rating: widget.attraction.rating);
    updated.setID(widget.attraction.getID());
    return updated;
  }
}
