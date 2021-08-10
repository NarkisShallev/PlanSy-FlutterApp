import 'package:flutter/material.dart';

// Have to be in Stack !!!

class DraggablePositionedFloatingActionButton extends StatefulWidget {
  final Color backgroundColor;
  final Function onPressed;
  final Widget child;
  final bool isNeedExtended;
  final double xPosition;
  final double yPosition;
  final String heroTag;

  const DraggablePositionedFloatingActionButton({
    this.backgroundColor,
    this.onPressed,
    this.child,
    this.isNeedExtended,
    this.xPosition,
    this.yPosition,
    this.heroTag,
  });

  @override
  _DraggablePositionedFloatingActionButtonState createState() =>
      _DraggablePositionedFloatingActionButtonState();
}

class _DraggablePositionedFloatingActionButtonState
    extends State<DraggablePositionedFloatingActionButton> {
  double xPosition;
  double yPosition;

  @override
  void initState() {
    super.initState();
    xPosition = widget.xPosition ?? 0;
    yPosition = widget.yPosition ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: yPosition + 11,
      right: xPosition + 15,
      child: GestureDetector(
        onPanUpdate: (tapInfo) {
          setState(() {
            xPosition -= tapInfo.delta.dx;
            yPosition -= tapInfo.delta.dy;
          });
        },
        child: widget.isNeedExtended
            ? FloatingActionButton.extended(
                heroTag: widget.heroTag,
                backgroundColor: widget.backgroundColor,
                onPressed: widget.onPressed,
                label: widget.child)
            : FloatingActionButton(
                heroTag: widget.heroTag,
                backgroundColor: widget.backgroundColor,
                onPressed: widget.onPressed,
                child: widget.child,
              ),
      ),
    );
  }
}
