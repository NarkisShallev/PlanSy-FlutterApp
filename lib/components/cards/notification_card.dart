import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/my_notification.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class NotificationCard extends StatefulWidget {
  final MyNotification notification;

  const NotificationCard({this.notification});

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool isSenderAdmin = false;

  @override
  void initState() {
    super.initState();
    if (widget.notification.sender == 'admin') {
      isSenderAdmin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight / 7,
      margin: EdgeInsets.only(bottom: getProportionateScreenWidth(5)),
      decoration: BoxDecoration(
        color: widget.notification.isNew ? Colors.blue[50] : Colors.white,
      ),
      child: buildNotificationCardContent(),
    );
  }

  Row buildNotificationCardContent() {
    return Row(
      children: [
        buildSenderCircleAvatar(),
        SizedBox(width: getProportionateScreenWidth(20)),
        buildNotificationContent(),
      ],
    );
  }

  CircleAvatar buildSenderCircleAvatar() {
    return CircleAvatar(
      radius: getProportionateScreenWidth(35),
      backgroundImage: isSenderAdmin
          ? AssetImage('images/planSy_transparent.png')
          : AssetImage('images/user.png'),
    );
  }

  Flexible buildNotificationContent() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: getProportionateScreenWidth(5)),
            child: buildNotificationTitle(),
          ),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildSendingTime(),
        ],
      ),
    );
  }

  Text buildNotificationTitle() {
    return Text(widget.notification.title, overflow: TextOverflow.clip, style: k13BlackStyle);
  }

  Text buildSendingTime() {
    return Text(widget.notification.now.toString(), style: k13BlackStyle);
  }
}
