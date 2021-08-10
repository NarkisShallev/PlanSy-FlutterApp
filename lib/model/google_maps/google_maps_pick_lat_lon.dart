import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:plansy_flutter_app/components/fields/input/build_address_text_form_field_for_search.dart';
import 'package:plansy_flutter_app/model/google_maps/google_maps_utilities.dart';
import 'package:plansy_flutter_app/utilities/size_config.dart';

class GoogleMapsPickLatLon extends StatefulWidget {
  final Address location;
  final Function setLocation;
  final Function setAddress;

  GoogleMapsPickLatLon({this.location, this.setLocation, this.setAddress});

  @override
  _GoogleMaps createState() => _GoogleMaps();
}

class _GoogleMaps extends State<GoogleMapsPickLatLon> {
  static final LatLng _kMapCenter = LatLng(19.018255973653343, 72.84793849278007);
  GoogleMapController mapController;
  CameraPosition _kInitialPosition;
  MapType mapType = MapType.normal;

  int markerIdCounter = 1;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;

  String searchedAddress = "";

  @override
  void initState() {
    super.initState();
    initCameraPosition();
  }

  void initCameraPosition() {
    if (widget.location == null) {
      _kInitialPosition = CameraPosition(
        target: _kMapCenter,
        zoom: 11.0,
        tilt: 0,
        bearing: 0,
      );
    } else {
      resetMarkers();
      addMarker(
          widget.location.coordinates,
          InfoWindow(
              title: "Location successfully selected!", snippet: widget.location.addressLine));

      _kInitialPosition = CameraPosition(
        target: LatLng(widget.location.coordinates.latitude, widget.location.coordinates.longitude),
        zoom: 17.0,
        tilt: 0,
        bearing: 0,
      );
    }
  }

  void resetMarkers() => markers = <MarkerId, Marker>{};

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
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueCyan,
          ),
        );
        markers[markerId] = newMarker;

        updateVars(markerId);
      });
    }
  }

  void updateVars(MarkerId markerId) {
    widget.setLocation(
      Address(
          coordinates: Coordinates(
            markers[markerId].position.latitude,
            markers[markerId].position.longitude,
          ),
          addressLine: markers[markerId].infoWindow.snippet),
    );
    widget.setAddress(markers[markerId].infoWindow.snippet);
  }

  void onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
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
        alignment: Alignment.center,
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
          Positioned(
            top: 100,
            child: buildAddressSearchField(),
          ),
        ],
      ),
    );
  }

  GoogleMap buildGoogleMap() {
    return GoogleMap(
      mapType: mapType,
      initialCameraPosition: _kInitialPosition,
      onMapCreated: (GoogleMapController controller) => mapController = controller,
      markers: Set<Marker>.of(markers.values),
      onTap: onMapTap,
      compassEnabled: true,
      mapToolbarEnabled: false,
      rotateGesturesEnabled: true,
      scrollGesturesEnabled: true,
      tiltGesturesEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
    );
  }

  void onMapTap(LatLng pos) async {
    Coordinates coordinates = Coordinates(pos.latitude, pos.longitude);

    Address location = await findFirstAddressFromCoordinates(coordinates);

    resetMarkers();
    addMarker(
      coordinates,
      InfoWindow(
        title: "Location successfully selected!",
        snippet: location.addressLine,
      ),
    );

    double currentZoom = await mapController.getZoomLevel();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: currentZoom, tilt: 0.0, bearing: 0),
      ),
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

  Container buildAddressSearchField() {
    return Container(
      width: 0.9 * SizeConfig.screenWidth,
      child: BuildAddressTextFormFieldForSearch(
        onChanged: onAddressInSearchFieldChanged,
      ),
    );
  }

  void onAddressInSearchFieldChanged(value) async {
    Address location = await findFirstAddressFromAddress(value);

    if (location != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(location.coordinates.latitude, location.coordinates.longitude),
            zoom: 17,
            tilt: 0.0,
            bearing: 0,
          ),
        ),
      );

      resetMarkers();
      addMarker(
        location.coordinates,
        InfoWindow(
          title: "Location successfully selected!",
          snippet: location.addressLine,
        ),
      );
    }
  }
}
