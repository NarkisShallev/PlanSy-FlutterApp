import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/components/cards/notification_card.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

class NotificationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer<Data>(
      builder: (context, notificationData, child) {
        return ListView.builder(
          padding: EdgeInsets.all(getProportionateScreenWidth(8)),
          itemBuilder: (context, index) {
            final notification = notificationData.notifications[index];
            return NotificationCard(notification: notification);
          },
          itemCount: notificationData.notificationsCount,
          shrinkWrap: true,
          physics: ScrollPhysics(),
        );
      },
    );
  }
}
