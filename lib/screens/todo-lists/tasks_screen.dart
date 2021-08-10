import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/components/buttons/Floating_action_button/add_task_floating_action_button.dart';
import 'package:plansy_flutter_app/components/dialogs/show_add_task_dialog.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/screens/todo-lists/tasks_list.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String newTaskTitle;
  int tripIdx;

  initState() {
    super.initState();
    tripIdx = Provider.of<Data>(context, listen: false).tripIndex;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          SafeArea(child: buildTasksScreenContent(context)),
          AddTaskFloatingActionButton(
            showAddDialog: () => showAddTaskDialog(context, newTaskTitle),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) => myAppBar(
      context: context,
      isArrowBack: true,
      isNotification: true,
      isEdit: false,
      isSave: false,
      isTabBar: false,
      isShare: false,
      titleText: 'TODO list',
      iconsColor: Colors.black);

  Column buildTasksScreenContent(BuildContext context) => Column(
        children: <Widget>[
          buildTitle(context),
          SizedBox(height: getProportionateScreenHeight(40)),
          buildTasksList(),
        ],
      );

  Row buildTitle(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('TODO list ', style: k28BlackStyle),
          Text('(${Provider.of<Data>(context).getTaskCount(tripIdx)} Tasks)'),
        ],
      );

  Expanded buildTasksList() => Expanded(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          decoration: BoxDecoration(color: Colors.white),
          child: TasksList(tripIdx: tripIdx),
        ),
      );
}
