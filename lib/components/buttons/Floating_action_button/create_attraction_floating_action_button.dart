import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/buttons/basic/draggable_floating_action_button.dart';
import 'package:plansy_flutter_app/screens/attractions/create_attraction_screen_page_1.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

class CreateAttractionFloatingActionButton extends StatelessWidget {
  final bool isAdmin;

  const CreateAttractionFloatingActionButton({this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return DraggablePositionedFloatingActionButton(
      backgroundColor: kPrimaryColor,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateAttractionScreen1(isAdmin: isAdmin),
        ),
      ),
      child: const Icon(Icons.add),
      isNeedExtended: false,
      heroTag: "createAttr",
    );
  }
}
