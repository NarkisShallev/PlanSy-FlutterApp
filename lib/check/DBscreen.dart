import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/components/appBar/my_appBar.dart';
import 'package:plansy_flutter_app/model/attraction.dart';
import 'package:plansy_flutter_app/screens/trips/trip_list.dart';
import 'package:provider/provider.dart';
import '../model/FireBase/FireBaseSingelton.dart';
import '../model/data.dart';

class DBScreen extends StatefulWidget {
  @override
  _DBScreenState createState() => _DBScreenState();
}

class _DBScreenState extends State<DBScreen> {
  void load() async {
    print('-----');
    List<Attraction> arr = await FireBaseSingleton().loadAttractions(context);
    print('-----');
    print(arr.length);
    for (var att in arr) {
      print("-----" + att.name);
    }
  }

  @mustCallSuper
  void initState() {
    super.initState();
    load();
  }

  @mustCallSuper
  void deactivate() {
    super.deactivate();
    List<Attraction> data =
        Provider.of<Data>(context, listen: false).attractions;
    for (var att in data) {
      print("-----" + att.name);
    }
    FireBaseSingleton().uploadAttractions(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
          context: context,
          isArrowBack: true,
          isNotification: true,
          isEdit: false,
          isSave: false,
          isTabBar: false,
          isShare: false,
          titleText: '', iconsColor: Colors.black),
      // drawer: HomeDrawer(auth: _auth, email: _loggedInUser.email),
      body: SingleChildScrollView(
        child: SafeArea(
          child: TripList(),
        ),
      ),
    );
  }
}
