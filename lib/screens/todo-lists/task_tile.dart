import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final Function checkboxCallback;
  final Function longPressCallback;

  TaskTile({this.isChecked, this.taskTitle, this.checkboxCallback, this.longPressCallback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: longPressCallback,
      title: buildTitle(),
      trailing: buildCheckbox(),
    );
  }

  Text buildTitle() {
    return Text(
      taskTitle ?? "",
      style: TextStyle(decoration: isChecked ? TextDecoration.lineThrough : null),
    );
  }

  Checkbox buildCheckbox() {
    return Checkbox(
      activeColor: kPrimaryColor,
      value: isChecked,
      onChanged: checkboxCallback,
    );
  }
}
