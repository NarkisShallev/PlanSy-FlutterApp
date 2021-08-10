import 'package:flutter/material.dart';
import 'package:plansy_flutter_app/check/googlemaps/animate_camera.dart';
import 'package:plansy_flutter_app/check/googlemaps/map_click.dart';
import 'package:plansy_flutter_app/check/googlemaps/map_coordinates.dart';
import 'package:plansy_flutter_app/check/googlemaps/map_ui.dart';
import 'package:plansy_flutter_app/check/googlemaps/marker_icons.dart';
import 'package:plansy_flutter_app/check/googlemaps/move_camera.dart';
import 'package:plansy_flutter_app/check/googlemaps/padding.dart';
import 'package:plansy_flutter_app/check/googlemaps/page.dart';
import 'package:plansy_flutter_app/check/googlemaps/place_marker.dart';
import 'package:plansy_flutter_app/check/googlemaps/place_polyline.dart';
import 'package:plansy_flutter_app/check/googlemaps/scrolling_map.dart';
import 'package:plansy_flutter_app/check/googlemaps/snapshot.dart';

final List<GoogleMapExampleAppPage> _allPages = <GoogleMapExampleAppPage>[
  MapUiPage(),
  MapCoordinatesPage(),
  MapClickPage(),
  AnimateCameraPage(),
  MoveCameraPage(),
  PlaceMarkerPage(),
  MarkerIconsPage(),
  ScrollingMapPage(),
  PlacePolylinePage(),
  PaddingPage(),
  SnapshotPage(),
];

class MapsDemo extends StatelessWidget {
  void _pushPage(BuildContext context, GoogleMapExampleAppPage page) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(page.title)),
          body: page,
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GoogleMaps examples')),
      body: ListView.builder(
        itemCount: _allPages.length,
        itemBuilder: (_, int index) => ListTile(
          leading: _allPages[index].leading,
          title: Text(_allPages[index].title),
          onTap: () => _pushPage(context, _allPages[index]),
        ),
      ),
    );
  }
}

