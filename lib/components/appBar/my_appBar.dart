import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/buttons/icons/arrow_icon_button.dart';
import 'package:plansy_flutter_app/components/buttons/icons/edit_icon_button.dart';
import 'package:plansy_flutter_app/components/buttons/icons/notification_icon_button.dart';
import 'package:plansy_flutter_app/components/buttons/icons/save_icon_button.dart';
import 'package:plansy_flutter_app/components/buttons/icons/share_icon_button.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';

AppBar myAppBar({
  BuildContext context,
  isArrowBack,
  isNotification,
  isEdit,
  isSave,
  isTabBar,
  isShare,
  Function onPressedArrow,
  Function onPressedEdit,
  Function onPressedSave,
  Function shareOnPressed,
  List<Tab> tabs,
  TabController tabController,
  @required String titleText,
  @required Color iconsColor,
}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text(titleText, style: TextStyle(color: kSecondaryColor)),
    centerTitle: true,
    leading: isArrowBack ? arrowIconButton(onPressedArrow, context, iconsColor) : null,
    actions: [
      Visibility(
        visible: isEdit,
        child: editIconButton(onPressedEdit, iconsColor),
      ),
      Visibility(
        visible: isSave,
        child: saveIconButton(onPressedSave, iconsColor),
      ),
      Visibility(
        visible: isShare,
        child: shareIconButton(shareOnPressed, iconsColor),
      ),
      Visibility(
        visible: isNotification,
        child: notificationIconButton(context, iconsColor),
      ),
    ],
    bottom: isTabBar ? TabBar(isScrollable: true, tabs: tabs, controller: tabController) : null,
  );
}
