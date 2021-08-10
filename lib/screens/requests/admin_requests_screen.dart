import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/screens/requests/admin_requests_list.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

class AdminRequestsScreen extends StatefulWidget {
  @override
  _AdminRequestsScreenState createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends State<AdminRequestsScreen> {
  bool isEmpty;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Provider.of<Data>(context, listen: true).checkIfRequestsIsEmpty();
    isEmpty = Provider.of<Data>(context, listen: true).isRequestsEmpty;
    return Scaffold(
      appBar: buildAppBar(context),
      body: SafeArea(
        child: buildAdminRequestsScreenContent(),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return myAppBar(
        context: context,
        isArrowBack: true,
        isNotification: true,
        isEdit: false,
        isSave: false,
        isTabBar: false,
        isShare: false,
        titleText: '',
        iconsColor: Colors.black);
  }

  Column buildAdminRequestsScreenContent() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
            child: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              child: isEmpty ? buildEmptyRequestsImage() : AdminRequestsList(),
            ),
          ),
        ),
      ],
    );
  }

  Image buildEmptyRequestsImage() {
    return Image(
      image: AssetImage('images/empty_requests.png'),
      fit: BoxFit.fitWidth,
    );
  }
}
