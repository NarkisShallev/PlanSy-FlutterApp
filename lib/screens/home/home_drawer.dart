import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/model/data.dart';
import 'package:plansy_flutter_app/screens/login/sign_in_screen.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatefulWidget {
  final FirebaseAuth auth;
  final String email;

  const HomeDrawer({this.auth, this.email});

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  String _avatarText;

  @override
  void initState() {
    super.initState();
    _avatarText = widget.email.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: null,
            accountEmail: Text(widget.email),
            currentAccountPicture: buildCurrentAccountPicture(context),
          ),
          buildSignOutListTile(),
          Divider(),
        ],
      ),
    );
  }

  CircleAvatar buildCurrentAccountPicture(BuildContext context) {
    return CircleAvatar(
      backgroundColor:
          Theme.of(context).platform == TargetPlatform.iOS ? Colors.blue : Colors.white,
      child: Text(
        _avatarText,
        style: TextStyle(fontSize: getProportionateScreenWidth(30)),
      ),
    );
  }

  ListTile buildSignOutListTile() {
    return ListTile(
      title: Text("Sign out"),
      trailing: Icon(Icons.logout, color: Colors.black, size: getProportionateScreenWidth(25)),
      onTap: _logOut,
    );
  }

  void _logOut() {
    Provider.of<Data>(context, listen: false).resetData();
    Navigator.pop(context);
    widget.auth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
  }
}
