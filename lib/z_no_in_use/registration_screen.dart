// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:plansy_flutter_app/z_no_in_use/email_field.dart';
// import 'package:plansy_flutter_app/z_no_in_use/login_screen.dart';
// import 'package:plansy_flutter_app/z_no_in_use/name_field.dart';
// import 'package:plansy_flutter_app/z_no_in_use/password_field.dart';
// import 'package:plansy_flutter_app/z_no_in_use/register_button.dart';
// import 'package:plansy_flutter_app/utilities/constants.dart';
//
// class RegistrationScreen extends StatefulWidget {
//   final _auth = FirebaseAuth.instance;
//
//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }
//
// class _RegistrationScreenState extends State<RegistrationScreen> {
//   bool _showSpinner = false;
//   String _userName;
//   String _email;
//   String _password;
//   bool _wrongRegistration = false;
//   String _error;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: ModalProgressHUD(
//         inAsyncCall: _showSpinner,
//         child: SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   RegistrationImage(),
//                   SizedBox(width: 20.0),
//                   RegistrationTitle(),
//                 ],
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               // registration error massage
//               _wrongRegistration
//                   ? Text(
//                       _error,
//                       style: TextStyle(color: Colors.red),
//                     )
//                   : SizedBox(height: 0),
//               NameField(
//                 press: (value) {
//                   _userName = value;
//                 },
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               EmailField(
//                 isWrong: _wrongRegistration,
//                 press: (value) {
//                   _email = value;
//                 },
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               PasswordField(
//                 isWrong: _wrongRegistration,
//                 press: (value) {
//                   _password = value;
//                 },
//               ),
//               SizedBox(
//                 height: 45.0,
//               ),
//               RegisterButton(
//                 press: () {
//                   _register();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _register() {
//     setState(() {
//       _showSpinner = true;
//     });
//     try {
//       _firebaseRegister();
//     } catch (e) {
//       _errorsDealing(e);
//     }
//   }
//
//   void _firebaseRegister() async {
//     final newUser = await widget._auth
//         .createUserWithEmailAndPassword(email: _email, password: _password);
//     await newUser.user.sendEmailVerification();
//     widget._auth.signOut();
//     if ((newUser != null)) {
//       setState(() {
//         _userName = newUser.user.displayName;
//         _showSpinner = false;
//         _wrongRegistration = false;
//       });
//       await _showConfirmEmailDialog();
//     }
//   }
//
//   void _errorsDealing(dynamic e) {
//     setState(() {
//       _showSpinner = false;
//       _wrongRegistration = true;
//     });
//     if ((e.code == 'email-already-in-use') ||
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
//   Future<void> _showConfirmEmailDialog() async {
//     await showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text(
//                   'An email has just been sent to you.',
//                 ),
//                 SizedBox(height: 15.0,),
//                 Text(
//                   'Click the link provided to complete the operation and then log in.',
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Log in'),
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => LoginScreen()));
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// class RegistrationTitle extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       'Registration',
//       style: kMediumTitleStyle,
//     );
//   }
// }
//
// class RegistrationImage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Hero(
//       tag: 'login_image',
//       child: Container(
//         child: Image(
//           image: AssetImage('images/login_image.jpg'),
//           height: 50.0,
//         ),
//       ),
//     );
//   }
// }
