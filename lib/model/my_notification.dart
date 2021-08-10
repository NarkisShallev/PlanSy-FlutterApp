import 'package:flutter/material.dart';

class MyNotification {
  bool isNew = false;
  final String title;
  final String sender;
  final String receiver;
  final String now;

  MyNotification({@required this.isNew, @required this.title, @required this.sender, @required this.receiver, @required this.now});
}
