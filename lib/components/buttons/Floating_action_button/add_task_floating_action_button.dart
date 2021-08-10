import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/buttons/basic/draggable_floating_action_button.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

class AddTaskFloatingActionButton extends StatelessWidget {
  final Function showAddDialog;

  const AddTaskFloatingActionButton({this.showAddDialog});

  @override
  Widget build(BuildContext context) {
    return DraggablePositionedFloatingActionButton(
      backgroundColor: kPrimaryColor,
      child: Icon(Icons.add),
      onPressed: () => showAddDialog(),
      isNeedExtended: false,
      heroTag: "addTask",
    );
  }
}
