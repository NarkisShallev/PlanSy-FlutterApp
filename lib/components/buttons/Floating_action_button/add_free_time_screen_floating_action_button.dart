import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/buttons/basic/draggable_floating_action_button.dart';
import 'package:plansy_flutter_app/components/dialogs/show_add_free_time_dialog.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

class AddFreeTimeFloatingActionButton extends StatelessWidget {
  final TabController tabController;

  const AddFreeTimeFloatingActionButton({this.tabController});

  @override
  Widget build(BuildContext context) {
    return DraggablePositionedFloatingActionButton(
      backgroundColor: kPrimaryColor,
      onPressed: () => showAddFreeTimeDialog(context, tabController),
      child: Text("+ Free time"),
      isNeedExtended: true,
      yPosition: 55,
      heroTag: "addFreeTime",
    );
  }
}
