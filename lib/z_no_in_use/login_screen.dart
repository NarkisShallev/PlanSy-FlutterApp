// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:plansy_flutter_app/z_no_in_use/email_field.dart';
// import 'package:plansy_flutter_app/z_no_in_use/forgot_password_button.dart';
// import 'package:plansy_flutter_app/z_no_in_use/login_button.dart';
// import 'package:plansy_flutter_app/z_no_in_use/new_user_register_button.dart';
// import 'package:plansy_flutter_app/z_no_in_use/password_field.dart';
// import 'package:plansy_flutter_app/screens/home/admin_home_screen.dart';
// import 'package:plansy_flutter_app/z_no_in_use/home_screen.dart';
// import 'package:plansy_flutter_app/utilities/constants.dart';
//
// class LoginScreen extends StatefulWidget {
//   final _auth = FirebaseAuth.instance;
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool _showSpinner = false;
//   String _email;
//   String _password;
//   bool _wrongLoggedIn = false;
//   String _error;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ModalProgressHUD(
//         inAsyncCall: _showSpinner,
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               LoginImage(),
//               SizedBox(height: 15.0),
//               LoginTitle(),
//               // login error massage
//               _wrongLoggedIn
//                   ? Text(_error, style: TextStyle(color: Colors.red))
//                   : SizedBox(height: 0),
//               EmailField(
//                 isWrong: _wrongLoggedIn,
//                 press: (value) {
//                   _email = value;
//                 },
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               PasswordField(
//                 isWrong: _wrongLoggedIn,
//                 press: (value) {
//                   _password = value;
//                 },
//               ),
//               ForgotPasswordButton(),
//               LoginButton(press: () {
//                 _login();
//               }),
//               SizedBox(
//                 height: 5.0,
//               ),
//               NewUserRegisterButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _login() {
//     // show spinner
//     setState(() {
//       _showSpinner = true;
//     });
//     try {
//       _firebaseLogin();
//     } catch (e) {
//       _errorsDealing(e);
//     }
//   }
//
//   void _unverifiedUserDealing() {
//     setState(() {
//       _showSpinner = false;
//       _wrongLoggedIn = true;
//       _error = "Error! Your email doesn't verified";
//     });
//   }
//
//   void _verifiedAndRegisteredUserDealing() {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => HomeScreen()));
//     setState(() {
//       _showSpinner = false;
//       _wrongLoggedIn = false;
//     });
//   }
//
//   void _adminDealing() {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => AdminHomeScreen()));
//     setState(() {
//       _showSpinner = false;
//       _wrongLoggedIn = false;
//     });
//   }
//
//   void _errorsDealing(dynamic e) {
//     setState(() {
//       _showSpinner = false;
//       _wrongLoggedIn = true;
//     });
//     if ((e.code == 'invalid-email') ||
//         (e.code == 'wrong-password') ||
//         (e.code == 'user-not-found') ||
//         (e.code == 'user-disabled') ||
//         (e.code == 'network-request-failed')) {
//       setState(() {
//         _error = "Error! " + e.code.replaceAll(RegExp('-'), ' ');
//       });
//     } else {
//       setState(() {
//         _error = "Error! Something went wrong";
//         print(e.code);
//       });
//     }
//   }
//
//   void _firebaseLogin() async {
//     final user = await widget._auth
//         .signInWithEmailAndPassword(email: _email, password: _password);
//     if ((!user.user.emailVerified) && (user.user.email != "admin@gmail.com")) {
//       _unverifiedUserDealing();
//     } else {
//       if (user != null) {
//         if (user.user.email == "admin@gmail.com") {
//           _adminDealing();
//         } else {
//           _verifiedAndRegisteredUserDealing();
//         }
//       }
//     }
//   }
// }
//
// class LoginTitle extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       'Log-In',
//       style: kBigTitleStyle,
//     );
//   }
// }
//
// class LoginImage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Hero(
//       tag: 'login_image',
//       child: Container(
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(10.0),
//           child: Image(
//             image: AssetImage('images/login_image.jpg'),
//             fit: BoxFit.fill,
//           ),
//         ),
//       ),
//     );
//   }
// }
