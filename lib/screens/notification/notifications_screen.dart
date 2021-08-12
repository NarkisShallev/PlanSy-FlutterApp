import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/model/FireBase/FireBaseSingelton.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/screens/notification/notification_list.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool isEmpty;

  @override
  void deactivate() {
    super.deactivate();
    List<String> ids = Provider.of<Data>(context, listen: false).notificationsIds;
    FireBaseSingleton().updateNotificationStatus(ids);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Provider.of<Data>(context, listen: true).checkIfNotificationsIsEmpty();
    isEmpty = Provider.of<Data>(context, listen: true).isNotificationsEmpty;
    return WillPopScope(
      onWillPop: () {
        Provider.of<Data>(context, listen: false).changeAllNewToOld();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: buildAppBar(context),
        body: SafeArea(
          child: buildNotificationScreenContent(),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return myAppBar(
        context: context,
        isArrowBack: true,
        isNotification: false,
        isEdit: false,
        isSave: false,
        isTabBar: false,
        isShare: false,
        onPressedArrow: () => Provider.of<Data>(context, listen: false).changeAllNewToOld(),
        titleText: '',
        iconsColor: Colors.black);
  }

  Column buildNotificationScreenContent() => Column(
        children: [
          Expanded(
            child: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              child: isEmpty ? buildEmptyNotificationsImage() : NotificationList(),
            ),
          ),
        ],
      );

  Image buildEmptyNotificationsImage() => Image(
      image: AssetImage('images/empty_notifications.png'),
      fit: BoxFit.fitWidth,
    );
}
