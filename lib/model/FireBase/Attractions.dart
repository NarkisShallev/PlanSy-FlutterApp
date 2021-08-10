import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:plansy_flutter_app/model/FireBase/FireBaseSingelton.dart';
import 'package:plansy_flutter_app/model/algorithm/algorithm_utilities.dart';
import 'package:plansy_flutter_app/model/google_maps/google_maps_utilities.dart';
import 'package:provider/provider.dart';

import '../attraction.dart';
import '../data.dart';

Future<String> addAttractionToFireBase(FirebaseFirestore firebaseFirestore, Attraction att) async {
  try {
    // get firebase collection and id field.
    var idDoc = await firebaseFirestore.collection('Attractions').doc('id').get();
    var id = idDoc.data()['counter'].toString();

    // add att to the DB.
    firebaseFirestore.collection('Attractions').doc(id).set({
      'Name': att.name,
      'Status': att.status,
      'ImageSrc': att.imageSrc,
      'Category': att.category,
      'Address': att.address,
      'Country': att.country,
      'Description': att.description,
      'OpeningTime': TimeOfDayExtension(att.openingTime).str(),
      'ClosingTime': TimeOfDayExtension(att.closingTime).str(),
      'WebSite': att.webSite,
      'Payment': att.pricing,
      'IsNeedToBuyTicketsInAdvance': att.isNeedToBuyTickets,
      'SuitableFor': att.suitableFor,
      'Recommendations': att.recommendations,
      'NumOfReviews': att.numOfReviews,
      'Rating': att.rating,
      'SuitableWeather': att.suitableSeason,
      'Duration': TimeOfDayExtension(att.duration).str(),
      'Priority': att.priority,
      "Latlnglocation": "${att.latLngLocation.latitude.toString()},${att.latLngLocation.longitude}",
    });
    att.setID(id);

    // update the id field - the number of the next attr.
    firebaseFirestore
        .collection('Attractions')
        .doc('id')
        .set({'counter': (int.parse(id) + 1).toString()});

    // 1 if succeeded 0 other.
    return id;
  } on FirebaseException catch (fException) {
    // only executed if error is of type Exception
    print(fException.message);
    return null;
  } catch (error) {
    // executed for errors of all types other than Exception
    print(error.toString());
    return null;
  }
}

// from the program to the db (at the end of the program)
Future<void> uploadAttractions(FirebaseFirestore firebaseFirestore, List<Attraction> attrs) async {
  for (var attr in attrs) {
    if (attr.status == 1) {
      await addAttractionToFireBase(firebaseFirestore, attr);
    }
  }
}

// using stream to load the attractions list.
Future<List<Attraction>> loadAttractions(FirebaseFirestore firebaseFirestore,
    BuildContext context) async {
  List<Attraction> attractionsList = [];
  var firebase = await firebaseFirestore.collection('Attractions').get();
  for (var attr in firebase.docs) {
    if (attr.id.compareTo('id') == 0 || attr.data()['Status'] == 2) {
      continue;
    }
    // extract all fields.
    String name = attr.data()['Name'];
    String imageSrc = attr.data()['ImageSrc'];
    String category = attr.data()['Category'];
    String address = attr.data()['Address'];
    String country = attr.data()['Country'];
    String description = attr.data()['Description'];
    String openingTime = attr.data()['OpeningTime'];
    String closingTime = attr.data()['ClosingTime'];
    String webSite = attr.data()['WebSite'];
    String payment = attr.data()['Payment'];
    String isNeedToBuyTicketsInAdvance = attr.data()['IsNeedToBuyTicketsInAdvance'];
    String suitableFor = attr.data()['SuitableFor'];
    String recommendations = attr.data()['Recommendations'];
    String numOfReviews = attr.data()['NumOfReviews'];
    String rating = attr.data()['Rating'];
    String suitableWeather = attr.data()['SuitableWeather'];
    String duration = attr.data()['Duration'];
    int priority = attr.data()['Priority'];
    int status = attr.data()['Status'];
    List<String> latlong =  attr.data()["Latlnglocation"].split(",");
    double latitude = double.tryParse(latlong[0]);
    double longitude = double.tryParse(latlong[1]);

    Attraction attraction = Attraction(
      status: status,
      name: name,
      imageSrc: imageSrc,
      category: category,
      address: address,
      country: country,
      description: description,
      openingTime: TimeOfDayExtension.timeFromStr(openingTime),
      closingTime: TimeOfDayExtension.timeFromStr(closingTime),
      webSite: webSite,
      pricing: payment,
      isNeedToBuyTickets: isNeedToBuyTicketsInAdvance,
      suitableFor: suitableFor,
      recommendations: recommendations,
      numOfReviews: numOfReviews,
      rating: rating,
      suitableSeason: suitableWeather,
      duration: TimeOfDayExtension.timeFromStr(duration),
      priority: priority,
      latLngLocation: Coordinates(latitude, longitude),
    );

    attraction.setID(attr.id);
    attractionsList.add(attraction);
  }
  Provider.of<Data>(context, listen: false).setAttractions(attractionsList);

  return attractionsList;
}

Future<Attraction> getAttractionFromFireBase(FirebaseFirestore firebaseFirestore, String id) async {
  var attrRef = firebaseFirestore.collection('Attractions').doc(id);
  var doc = await attrRef.get();
  if (!doc.exists) {
    print('No such document!');
  } else {
    String opening = doc.data()["OpeningTime"];
    String closing = doc.data()["ClosingTime"];
    String duration = doc.data()["Duration"];
    int status = doc.data()['Status'];
    List<String> latlong =  doc.data()["Latlnglocation"].split(",");
    double latitude = double.tryParse(latlong[0]);
    double longitude = double.tryParse(latlong[1]);
    Attraction a = Attraction(
        status: status,
        name: doc.data()["Name"],
        imageSrc: doc.data()["ImageSrc"],
        category: doc.data()["Category"],
        address: doc.data()["Address"],
        country: doc.data()["Country"],
        description: doc.data()["Description"],
        openingTime: TimeOfDayExtension.timeFromStr(opening),
        closingTime: TimeOfDayExtension.timeFromStr(closing),
        webSite: doc.data()["WebSite"],
        pricing: doc.data()["Payment"],
        isNeedToBuyTickets: doc.data()["IsNeedToBuyTicketsInAdvance"],
        suitableFor: doc.data()["SuitableFor"],
        suitableSeason: doc.data()["SuitableWeather"],
        duration: TimeOfDayExtension.timeFromStr(duration),
        recommendations: doc.data()["Recommendations"],
        numOfReviews: doc.data()["NumOfReviews"],
        rating: doc.data()["Rating"],
        priority: 0,
    latLngLocation: Coordinates(latitude, longitude));
    a.setID(id);
    return a;
  }
}

Future<void> changeAttraction(FirebaseFirestore firebaseFirestore, String id, Map<String, dynamic> changes) {
  var attrRef = firebaseFirestore.collection('Attractions').doc(id);
  attrRef.update(changes);
}

Future<void> removeAttractionFromFireBase(FirebaseFirestore firebaseFirestore, String id) async {
  var attrRef = await firebaseFirestore.collection('Attractions').doc(id).delete();
}