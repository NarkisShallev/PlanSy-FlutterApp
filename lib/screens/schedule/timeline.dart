import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/buttons/Floating_action_button/add_attractions_floating_action_button.dart';
import 'package:plansy_flutter_app/components/buttons/Floating_action_button/add_free_time_screen_floating_action_button.dart';
import 'package:plansy_flutter_app/model/activity.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/model/google_maps/google_maps_create_route_of_activities_markers.dart';
import 'package:plansy_flutter_app/screens/schedule/my_time_line_tile.dart';
import 'package:plansy_flutter_app/screens/schedule/timeline_indicator.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

class Timeline extends StatelessWidget {
  final int dayNum;
  final TabController tabController;

  const Timeline({this.dayNum, this.tabController});

  @override
  Widget build(BuildContext context) {
    List<Activity> activities = Provider.of<Data>(context, listen: false).activities[dayNum];
    int activitiesCount = Provider.of<Data>(context, listen: false).getDayActivitiesCount(dayNum);
    SizeConfig().init(context);
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            child: buildTimelineContent(activitiesCount, activities),
          ),
        ),
        AddAttractionsFloatingActionButton(),
        AddFreeTimeFloatingActionButton(tabController: tabController),
      ],
    );
  }

  Column buildTimelineContent(int activitiesCount, List<Activity> activities) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.02),
        buildTimelineList(dayNum),
        SizedBox(height: getProportionateScreenHeight(20)),
        Visibility(
          visible: activitiesCount > 0,
          child: GoogleMapsCreateRouteOfActivitiesMarkers(activities: activities),
        ),
        SizedBox(height: getProportionateScreenHeight(170)),
      ],
    );
  }

  Consumer<Data> buildTimelineList(int dayNum) => Consumer<Data>(
        builder: (context, activityData, child) => ListView.builder(
          itemBuilder: (context, index) {
            final activity = activityData.activities[dayNum][index];
            if (index == 0) {
              return buildFirstTimeLineTile(activity);
            } else if (index == activityData.getDayActivitiesCount(dayNum) - 1) {
              return buildLastTimeLineTile(activity);
            } else {
              return buildMiddleTimeLineTile(activity);
            }
          },
          itemCount: activityData.getDayActivitiesCount(dayNum),
          shrinkWrap: true,
          physics: ScrollPhysics(),
        ),
      );

  MyTimeLineTile buildFirstTimeLineTile(Activity activity) => MyTimeLineTile(
        indicator: TimelineIndicator(imageSrc: activity.imageSrc),
        hour: activity.hour,
        attractionName: activity.attractionName,
        imageSrc: activity.imageSrc,
        address: activity.address,
        isNeedToBuyTicketsInAdvance: activity.isNeedToBuyTicketsInAdvance,
        duration: activity.duration,
        isFirst: true,
        isLast: false,
      );

  MyTimeLineTile buildLastTimeLineTile(Activity activity) => MyTimeLineTile(
        indicator: TimelineIndicator(imageSrc: activity.imageSrc),
        hour: activity.hour,
        attractionName: activity.attractionName,
        imageSrc: activity.imageSrc,
        address: activity.address,
        isNeedToBuyTicketsInAdvance: activity.isNeedToBuyTicketsInAdvance,
        duration: activity.duration,
        isFirst: false,
        isLast: true,
      );

  MyTimeLineTile buildMiddleTimeLineTile(Activity activity) => MyTimeLineTile(
        indicator: TimelineIndicator(imageSrc: activity.imageSrc),
        hour: activity.hour,
        attractionName: activity.attractionName,
        imageSrc: activity.imageSrc,
        address: activity.address,
        isNeedToBuyTicketsInAdvance: activity.isNeedToBuyTicketsInAdvance,
        duration: activity.duration,
        isFirst: false,
        isLast: false,
      );
}
