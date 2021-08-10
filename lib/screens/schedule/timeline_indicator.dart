import 'package:flutter/material.dart';

class TimelineIndicator extends StatelessWidget {
  final String imageSrc;

  const TimelineIndicator({this.imageSrc});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: imageSrc == "free_time.png"
              ? AssetImage("images/" + imageSrc)
              : NetworkImage(imageSrc),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
