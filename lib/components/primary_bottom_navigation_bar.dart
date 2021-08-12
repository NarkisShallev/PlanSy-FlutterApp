import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/buttons/icons/browse_icon_button.dart';
import 'package:plansy_flutter_app/components/buttons/icons/cart_icon_button.dart';
import 'package:plansy_flutter_app/components/buttons/icons/home_icon_button.dart';
import 'package:plansy_flutter_app/components/buttons/icons/wish_list_icon_button.dart';
import 'package:plansy_flutter_app/utilities/constants.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class PrimaryBottomNavigationBar extends StatelessWidget {
  final bool isHome;
  final bool isBrowse;
  final bool isWishList;
  final bool isCart;
  final int tripIndex;

  PrimaryBottomNavigationBar({
    @required this.isHome,
    this.isBrowse,
    @required this.isWishList,
    @required this.isCart,
    this.tripIndex,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(35)),
      height: getProportionateScreenHeight(90),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(getProportionateScreenWidth(20)),
            topRight: Radius.circular(getProportionateScreenWidth(20))),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -7),
            blurRadius: getProportionateScreenWidth(33),
            color: kSecondaryColor.withOpacity(0.11),
          ),
        ],
      ),
      child: buildIcons(context),
    );
  }

  Row buildIcons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        homeIconButton(context, isHome),
        browseIconButton(context, isBrowse),
        cartIconButton(context, isCart, tripIndex),
        wishListIconButton(context, isWishList),
      ],
    );
  }
}
