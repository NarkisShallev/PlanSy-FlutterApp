import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:plansy_flutter_app/model/activity.dart';

class GoogleMapsCreateRouteOfActivitiesMarkers extends StatefulWidget {
  final List<Activity> activities;

  const GoogleMapsCreateRouteOfActivitiesMarkers({this.activities});

  @override
  _GoogleMaps createState() => _GoogleMaps();
}

class _GoogleMaps extends State<GoogleMapsCreateRouteOfActivitiesMarkers> {
  static final LatLng _kMapCenter = LatLng(19.018255973653343, 72.84793849278007);
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _kInitialPosition;
  MapType mapType = MapType.normal;

  int markerIdCounter = 1;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;

  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 0;
  PolylineId selectedPolyline;

  @override
  void initState() {
    super.initState();
    addActivitiesMarkers();
    addActivitiesPolylines();
    initCameraPosition();
  }

  void addActivitiesMarkers() {
    for (Activity activity in widget.activities) {
      if (activity.latLngLocation != null) {
        addMarker(
          activity.latLngLocation,
          InfoWindow(
            title: activity.attractionName,
            snippet: activity.address,
          ),
        );
      }
    }
  }

  void initCameraPosition() {
    Activity firstActivityHasLatLng = findFirstActivityHasLatLng();
    if (firstActivityHasLatLng == null) {
      _kInitialPosition = CameraPosition(
        target: _kMapCenter,
        zoom: 11.0,
        tilt: 0,
        bearing: 0,
      );
    } else {
      _kInitialPosition = CameraPosition(
        target: LatLng(firstActivityHasLatLng.latLngLocation.latitude,
            firstActivityHasLatLng.latLngLocation.longitude),
        zoom: 11.0,
        tilt: 0,
        bearing: 0,
      );
    }
  }

  Activity findFirstActivityHasLatLng() {
    for (Activity activity in widget.activities) {
      if (activity.latLngLocation != null) {
        return activity;
      }
    }
    return null;
  }

  void addMarker(Coordinates coordinates, InfoWindow infoWindow) {
    final MarkerId markerId = MarkerId(getPolylineId());

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(coordinates.latitude, coordinates.longitude),
      infoWindow: InfoWindow(title: infoWindow.title, snippet: infoWindow.snippet),
      onTap: () => onMarkerTapped(markerId),
      onDragEnd: (LatLng position) => onMarkerDragEnd(markerId, position),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  String getPolylineId() {
    final String markerIdVal = 'marker_id_$markerIdCounter';
    markerIdCounter++;
    return markerIdVal;
  }

  void onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        final MarkerId previousMarkerId = selectedMarker;
        if (previousMarkerId != null && markers.containsKey(previousMarkerId)) {
          final Marker resetOld =
              markers[previousMarkerId].copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[previousMarkerId] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  void onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(child: const Text('OK'), onPressed: () => Navigator.of(context).pop())
            ],
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 66),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Old position: ${tappedMarker.position}'),
                  Text('New position: $newPosition'),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void addActivitiesPolylines() {
    for (int i = 0; i < widget.activities.length - 1; i++) {
      if ((widget.activities[i].latLngLocation != null) &&
          (widget.activities[i + 1].latLngLocation != null)) {
        addPolyline(Colors.orange, widget.activities[i], widget.activities[i + 1]);
      }
    }
  }

  void addPolyline(Color color, Activity activity1, Activity activity2) {
    final PolylineId polylineId = getMarkerId();

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: color,
      width: 5,
      points: createPoints(activity1, activity2),
      onTap: () => onPolylineTapped(polylineId),
    );

    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  PolylineId getMarkerId() {
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    return PolylineId(polylineIdVal);
  }

  void onPolylineTapped(PolylineId polylineId) {
    setState(() {
      selectedPolyline = polylineId;
    });
  }

  List<LatLng> createPoints(Activity activity1, Activity activity2) {
    final List<LatLng> points = <LatLng>[];
    points.add(LatLng(activity1.latLngLocation.latitude, activity1.latLngLocation.longitude));
    points.add(LatLng(activity2.latLngLocation.latitude, activity2.latLngLocation.longitude));
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: buildGoogleMap(),
    );
  }

  GoogleMap buildGoogleMap() {
    return GoogleMap(
      mapType: mapType,
      initialCameraPosition: _kInitialPosition,
      onMapCreated: (GoogleMapController controller) => _controller.complete(controller),
      markers: Set<Marker>.of(markers.values),
      polylines: Set<Polyline>.of(polylines.values),
      mapToolbarEnabled: true,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        new Factory<OneSequenceGestureRecognizer>(
          () => new EagerGestureRecognizer(),
        ),
      ].toSet(),
    );
  }
}
