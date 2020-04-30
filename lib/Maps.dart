import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import 'Store.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  void _settingModalBottomSheet(BuildContext context, String title,
      int confirmed, int recovered, int deaths, String code) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return FittedBox(
                      child: Container(
              color: Colors.grey[200],
              // height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(title.toUpperCase(),
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text("Confirmed Cases: $confirmed",
                                style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text("Recovered Cases: $recovered",
                                style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text("Deaths: $deaths",
                                style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Flags.getMiniFlag(
                            "$code",
                            MediaQuery.of(context).size.height * 0.1,
                            MediaQuery.of(context).size.height * 0.1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  GoogleMapController mapController;

  String _mapStyle;

  @override
  void initState() {
    super.initState();

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
          onTap: (LatLng point) async {
            print(point);
            var coordinates = new Coordinates(point.latitude, point.longitude);
            var addresses =
                await Geocoder.local.findAddressesFromCoordinates(coordinates);
            var countryName = addresses.first.countryName;
            print(countryName);
            var data = {};
            
            for (var country in store.summary['Countries']) {
              if (country['Country'].toString().startsWith(countryName)) {
                data = country;
                break;
              } else {
                continue;
              }
            }
            _settingModalBottomSheet(
                context,
                countryName,
                data['TotalConfirmed']==null?0:data['TotalConfirmed'],
                data['TotalRecovered']==null?0:data['TotalRecovered'],
                data['TotalDeaths']==null?0:data['TotalDeaths'],
                data['CountryCode']==null?"":data['CountryCode']);
          },
        ));
      },
    );
  }
}
