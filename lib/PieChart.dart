import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'Store.dart';

class GlobalData {
  String title;
  int number;
  Color colorVal;
  GlobalData(this.title, this.number, this.colorVal);
}

class PieChart extends StatefulWidget {
  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  List<charts.Series<GlobalData, String>> _seriesPieData;
  @override
  void initState() {
    super.initState();
    _seriesPieData = List<charts.Series<GlobalData, String>>();
    Provider.of<Store>(context).getGlobalSummary().then((data) {
      _getGlobalSummary(
          data['Global']['TotalConfirmed'],
          data['Global']['NewConfirmed'],
          data['Global']['TotalDeaths'],
          data['Global']['NewDeaths'],
          data['Global']['TotalRecovered'],
          data['Global']['NewRecovered']);
    });
  }

  void _getGlobalSummary(int totalConfirmed, int newConfirmed, int totalDeaths,
      int newDeaths, int totalRecovered, int newRecovered) {
    var pieData = [
      new GlobalData("Total Confirmed", totalConfirmed, Colors.blue),
      new GlobalData("New Confirmed", newConfirmed, Colors.amber),
      new GlobalData("Total Deaths", totalDeaths, Colors.red),
      new GlobalData("New Deaths", newDeaths, Colors.redAccent),
      new GlobalData("Total Recovered", totalRecovered, Colors.green),
      new GlobalData("New Recovered", newRecovered, Colors.greenAccent),
      // new GlobalData("Total Confirmed", 145, Colors.blue),
      // new GlobalData("New Confirmed", 149, Colors.amber),
      // new GlobalData("Total Deaths", 100, Colors.red),
    ];

    _seriesPieData.add(charts.Series(
        data: pieData,
        domainFn: (GlobalData data, _) => data.title,
        measureFn: (GlobalData data, _) => data.number,
        colorFn: (GlobalData data, _) =>
            charts.ColorUtil.fromDartColor(data.colorVal),
        id: "Global COVID-19 Data",
        labelAccessorFn: (GlobalData row, _) => '${row.number}'));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<Store>(context).getGlobalSummary(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                body: charts.PieChart(
              _seriesPieData,
              animate: true,
              animationDuration: Duration(seconds: 1),
              behaviors: [
                new charts.DatumLegend(
                  outsideJustification: charts.OutsideJustification.endDrawArea,
                  horizontalFirst: false,
                  desiredMaxRows: 2,
                  cellPadding: new EdgeInsets.only(right: 4, bottom: 4),
                  entryTextStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.white, fontSize: 16),
                ),
              ],
              defaultRenderer: new charts.ArcRendererConfig(
                  arcWidth: 100,
                  arcRendererDecorators: [
                    new charts.ArcLabelDecorator(
                        labelPosition: charts.ArcLabelPosition.inside)
                  ]),
            ));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
