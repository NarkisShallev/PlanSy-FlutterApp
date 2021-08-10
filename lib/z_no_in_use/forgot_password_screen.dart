// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:plansy_flutter_app/z_no_in_use/email_field.dart';
// import 'package:plansy_flutter_app/z_no_in_use/login_screen.dart';
// import 'package:plansy_flutter_app/z_no_in_use/reset_password_button.dart';
// import 'package:plansy_flutter_app/utilities/constants.dart';
//
// class ForgotPasswordScreen extends StatefulWidget {
//   final _auth = FirebaseAuth.instance;
//
//   @override
//   _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
// }
//
// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   bool _showSpinner = false;
//   String _email;
//   bool _wrongReset = false;
//   String _error;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//       ),
//       body: ModalProgressHUD(
//         inAsyncCall: _showSpinner,
//         child: SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ForgotPasswordTitle(),
//               // forgot password error massage
//               _wrongReset
//                   ? Text(
//                       _error,
//                       style: TextStyle(color: Colors.red),
//                     )
//                   : SizedBox(height: 0),
//               EmailField(
//                 isWrong: _wrongReset,
//                 press: (value) {
//                   _email = value;
//                 },
//               ),
//               SizedBox(height: 40),
//               ResetPasswordButton(
//                 press: () {
//                   _resetPassword();
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _resetPassword() {
//     setState(() {
//       _showSpinner = true;
//     });
//     try {
//       _firebaseResetPassword();
//     } catch (e) {
//       _errorsDealing(e);
//     }
//   }
//
//   void _firebaseResetPassword() async {
//     await widget._auth.sendPasswordResetEmail(email: _email);
//     await _showConfirmEmailDialog(context);
//     setState(() {
//       _showSpinner = false;
//       _wrongReset = false;
//     });
//   }
//
//   void _errorsDealing(dynamic e) {
//     setState(() {
//       _showSpinner = false;
//       _wrongReset = true;
//     });
//     if ((e.code == 'invalid-email') || (e.code == 'network-request-failed')) {
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
//   Future<void> _showConfirmEmailDialog(BuildContext context) async {
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
// class ForgotPasswordTitle extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       'Enter your email:',
//       style: kMediumTitleStyle,
//     );
//   }
// }
