import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class GoogleMapsShowAddress extends StatefulWidget {
  final String name;
  final String address;
  final Coordinates latLngLocation;

  const GoogleMapsShowAddress({this.name, this.address, this.latLngLocation});

  @override
  _GoogleMaps createState() => _GoogleMaps();
}

class _GoogleMaps extends State<GoogleMapsShowAddress> {
  static final LatLng _kMapCenter = LatLng(19.018255973653343, 72.84793849278007);
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _kInitialPosition;
  MapType mapType = MapType.normal;

  int markerIdCounter = 1;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;

  @override
  void initState() {
    super.initState();
    initCameraPosition();
  }

  void initCameraPosition() {
    if (widget.latLngLocation == null) {
      _kInitialPosition = CameraPosition(
        target: _kMapCenter,
        zoom: 11.0,
        tilt: 0,
        bearing: 0,
      );
    } else {
      addMarker(
        widget.latLngLocation,
        InfoWindow(
          title: widget.name,
          snippet: widget.address,
        ),
      );

      _kInitialPosition = CameraPosition(
        target: LatLng(widget.latLngLocation.latitude, widget.latLngLocation.longitude),
        zoom: 17.0,
        tilt: 0,
        bearing: 0,
      );
    }
  }

  void addMarker(Coordinates coordinates, InfoWindow infoWindow) {
    final MarkerId markerId = getMarkerId();

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

  MarkerId getMarkerId() {
    final String markerIdVal = 'marker_id_$markerIdCounter';
    markerIdCounter++;
    return MarkerId(markerIdVal);
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            child: buildGoogleMap(),
          ),
          Positioned(
            bottom: 100,
            right: 5,
            child: buildChangeMapTypeButton(),
          ),
        ],
      ),
    );
  }

  GoogleMap buildGoogleMap() {
    return GoogleMap(
      mapType: mapType,
      initialCameraPosition: _kInitialPosition,
      onMapCreated: (GoogleMapController controller) => _controller.complete(controller),
      markers: Set<Marker>.of(markers.values),
      compassEnabled: true,
      mapToolbarEnabled: true,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
    );
  }

  Widget buildChangeMapTypeButton() {
    return InkWell(
      onTap: () {
        if (mapType == MapType.satellite) {
          setState(() {
            mapType = MapType.normal;
          });
        } else {
          setState(() {
            mapType = MapType.satellite;
          });
        }
      },
      child: Image(
        height: getProportionateScreenHeight(70),
        image: mapType == MapType.satellite
            ? AssetImage("images/layers.png")
            : AssetImage("images/satellite.png"),
        fit: BoxFit.fill,
      ),
    );
  }
}
