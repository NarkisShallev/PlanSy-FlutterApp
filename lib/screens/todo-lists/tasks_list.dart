import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/task.dart';
import 'package:plansy_flutter_app/screens/todo-lists/task_tile.dart';
import 'package:provider/provider.dart';

class TasksList extends StatelessWidget {
  final int tripIdx;

  TasksList({@required this.tripIdx});

  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = taskData.getTasks(tripIdx)[index];
            return buildTaskTileInstance(task, taskData);
          },
          itemCount: taskData.getTaskCount(tripIdx),
        );
      },
    );
  }

  TaskTile buildTaskTileInstance(Task task, Data taskData) => TaskTile(
        taskTitle: task.name,
        isChecked: task.isDone,
        checkboxCallback: (checkboxState) => taskData.markLineOnTask(task, tripIdx),
        longPressCallback: () => taskData.deleteTask(tripIdx, task),
      );
}
