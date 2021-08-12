import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/dialogs/show_remove_attraction_dialog.dart';
import 'package:plansy_flutter_app/model/attraction.dart';

class RemoveCircleButton extends StatelessWidget {
  final Function removeFromListCallback;
  final Attraction attraction;

  const RemoveCircleButton({this.removeFromListCallback, this.attraction});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.remove_circle_outline, color: Colors.red),
      onPressed: () async => await showRemoveAttractionDialog(context, removeFromListCallback, attraction),
    );
  }
}
