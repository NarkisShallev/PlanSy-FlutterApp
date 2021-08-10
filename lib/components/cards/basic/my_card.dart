import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final double leftMargin;
  final double rightMargin;
  final double topMargin;
  final double bottomMargin;
  final Widget child;
  final double height;
  final double width;
  final Color color;

  const MyCard(
      {this.leftMargin,
      this.rightMargin,
      this.topMargin,
      this.bottomMargin,
      @required this.child,
      this.height,
      this.width,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(
          left: leftMargin, right: rightMargin, top: topMargin, bottom: bottomMargin),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 4), blurRadius: 20, color: Color(0xFFB0CCE1).withOpacity(0.32)),
        ],
        // image: DecorationImage(
        //   colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop),
        //   image: AssetImage("images/$image"),
        //   fit: BoxFit.cover,
        // ),
      ),
      child: Material(color: Colors.transparent, child: child),
    );
  }
}
