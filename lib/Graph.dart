import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:provider/provider.dart';

import 'Store.dart';

class Graphs extends StatelessWidget {
  String countryName;
  String state;
  int rate;
  Graphs(String countryName, String state, int rate) {
    this.countryName = countryName;
    this.state = state;
    this.rate = rate;
  }
  var data = [0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0];
  @override
  Widget build(BuildContext context) {
    List dataPoints = [];
    state == "Recoveries"
        ? dataPoints =
            Provider.of<Store>(context).getDataPointsForRecovery(countryName)
        : dataPoints =
            Provider.of<Store>(context).getDataPointsForDeaths(countryName);
    return new Scaffold(
      appBar: AppBar(title: Text("$state over last 30 days")),
      body: Column(
        children: <Widget>[
          Text("${state.toUpperCase()} TODAY: ${dataPoints.last.round()}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(
            "${state.toUpperCase()} 30 DAYS AGO: ${dataPoints[0].round()}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("RATE OF ${state.toUpperCase()} OVER 30 DAYS: $rate%"),
                  new Container(
                    width: 400.0,
                    height: 300.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Sparkline(
                        data: dataPoints,
                        lineColor:
                            state == "Recoveries" ? Colors.green : Colors.red,
                        fillMode: FillMode.below,
                        fillColor: state == "Recoveries"
                            ? Colors.lightGreen[200]
                            : Colors.red[200],
                        fillGradient: new LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: state == "Recoveries"
                              ? [Colors.green[800], Colors.green[200]]
                              : [Colors.red[800], Colors.red[200]],
                        ),
                        pointsMode: PointsMode.all,
                        pointSize: 8.0,
                        pointColor: Colors.blue,
                      ),
                    ),
                  ),
                  Text(
                    "Curve for $state over last 30 days",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
