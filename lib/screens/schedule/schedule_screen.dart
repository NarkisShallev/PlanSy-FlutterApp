import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/trip.dart';
import 'package:plansy_flutter_app/screens/schedule/timeline.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

class ScheduleScreen extends StatefulWidget {
  final ScreenshotController screenshotController = ScreenshotController();
  final int tripIndex;

  ScheduleScreen({this.tripIndex});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with TickerProviderStateMixin {
  List<Tab> _tabs = [];
  List<Widget> _generalWidgets = [];
  TabController _tabController;
  Trip trip;

  @override
  void initState() {
    super.initState();
    trip = Provider.of<Data>(context, listen: false).trips[widget.tripIndex];
    _tabs = getTabs(
        trip.getLastDateInDateTimeFormat().difference(trip.getFirstDateInDateTimeFormat()).inDays +
            1);
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  List<Tab> getTabs(int count) {
    _tabs.clear();
    for (int i = 0; i < count; i++) {
      String thisDay = DateFormat('MM/dd/yyyy')
          .format(trip.getFirstDateInDateTimeFormat().add(Duration(days: i)));
      _tabs.add(Tab(child: Text(thisDay)));
    }
    return _tabs;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Screenshot(
      controller: widget.screenshotController,
      child: buildScreenshotContent(context),
    );
  }

  DefaultTabController buildScreenshotContent(BuildContext context) => DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          appBar: buildMyAppBar(context),
          body: SafeArea(
            child: TabBarView(children: getWidgets(), controller: _tabController),
          ),
        ),
      );

  AppBar buildMyAppBar(BuildContext context) {
    return myAppBar(
        context: context,
        isArrowBack: true,
        isNotification: true,
        isEdit: false,
        isSave: false,
        isTabBar: true,
        isShare: true,
        tabs: _tabs,
        tabController: _tabController,
        shareOnPressed: () => takeScreenshot(),
        titleText: 'Schedule',
        iconsColor: Colors.black);
  }

  void takeScreenshot() async {
    final imageFile = await widget.screenshotController.capture();
    Share.shareFiles([imageFile.path]);
  }

  List<Widget> getWidgets() {
    _generalWidgets.clear();
    for (int i = 0; i < _tabs.length; i++) {
      _generalWidgets.add(
        Timeline(
          tripIndex: widget.tripIndex,
          dayNum: i,
          tabController: _tabController,
        ),
      );
    }
    return _generalWidgets;
  }
}
