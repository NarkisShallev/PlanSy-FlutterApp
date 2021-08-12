import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/buttons/basic/draggable_floating_action_button.dart';
import 'package:plansy_flutter_app/screens/attractions/browse_screen.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

class AddAttractionsFloatingActionButton extends StatelessWidget {
  final int tripIndex;

  const AddAttractionsFloatingActionButton({this.tripIndex});

  @override
  Widget build(BuildContext context) {
    return DraggablePositionedFloatingActionButton(
      backgroundColor: kPrimaryColor,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BrowseScreen(
            isAdmin: false,
          ),
        ),
      ),
      child: Text("+ Attractions"),
      isNeedExtended: true,
      heroTag: "addAttr",
    );
  }
}
