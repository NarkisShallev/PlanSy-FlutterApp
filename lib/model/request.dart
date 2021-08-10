import 'package:flutter/cupertino.dart';
import 'package:plansy_flutter_app/model/attraction.dart';

class Request {
  final Attraction updatedAttraction;
  final String sender;
  final String originalAttractionIdInFireBase;
  String _id;

  Request({@required this.updatedAttraction, @required this.sender,
    @required this.originalAttractionIdInFireBase});

  void setId(String id) => this._id = id;

  String getId() => _id;
}