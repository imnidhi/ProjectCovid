import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:project_covid/CountryData.dart';
import 'package:provider/provider.dart';

import 'Store.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  GoogleMapController mapController;
  String _mapStyle;

  @override
  void initState() {
    super.initState();
    Provider.of<Store>(context, listen: false).getAllMarkers();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(
      builder: (context, store, child) {
        return Scaffold(
            body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition:
              CameraPosition(target: LatLng(20.5937, 78.9629), zoom: 0),
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
            mapController.setMapStyle(_mapStyle);
            
          },
          markers: Set.from(store.allMarkers),
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
        ));
      },
    );
  }
}
