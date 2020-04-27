import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  Completer<GoogleMapController> _controller = Completer();
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(20.5937, 78.9629), zoom: 0),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        myLocationButtonEnabled: false,
      )
    );
  }
}
