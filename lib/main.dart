import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/screens/login/sign_in_screen.dart';
import 'package:plansy_flutter_app/utilities/theme.dart';
import 'model/data.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PlanSyApp());
}

class PlanSyApp extends StatefulWidget {
  @override
  _PlanSyAppState createState() => _PlanSyAppState();
}

class _PlanSyAppState extends State<PlanSyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Data(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PlanSy App',
        theme: theme(),
        home: SignInScreen(),
      ),
    );
  }
}
