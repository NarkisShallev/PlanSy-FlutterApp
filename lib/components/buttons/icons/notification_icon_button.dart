import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/screens/notification/notifications_screen.dart';
import 'package:provider/provider.dart';

IconButton notificationIconButton(BuildContext context, Color iconsColor) {
  return IconButton(
    icon: Provider.of<Data>(context, listen: true).isNewNotificationAdded
        ? Icon(Icons.notifications_active_outlined, color: iconsColor)
        : Icon(Icons.notifications_none, color: iconsColor),
    onPressed: () {
      // Provider.of<Data>(context, listen: false).isNewNotificationAdded = false;
      Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
    },
  );
}
