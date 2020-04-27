import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';

import 'Store.dart';

class GlobalData {
  String title;
  int number;
  Color colorVal;
  GlobalData(this.title, this.number, this.colorVal);
}

class PieChart extends StatefulWidget {
  int totalConfirmed;
  int newConfirmed;
  int totalDeaths;
  int newDeaths;
  int totalRecovered;
  int newRecovered;
  PieChart(this.totalConfirmed, this.newConfirmed, this.totalDeaths,
      this.newDeaths, this.totalRecovered, this.newRecovered);

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  List<charts.Series<GlobalData, String>> _seriesPieData;
  @override
  void initState() {
    super.initState();
    _seriesPieData = List<charts.Series<GlobalData, String>>();
    dataForPieChart();
  }

  void dataForPieChart() {
    var pieData = [

      new GlobalData("New Confirmed", widget.newConfirmed, Color(0xff9552EA)),
      new GlobalData("Total Deaths", widget.totalDeaths, Color(0xffF54F52)),
      new GlobalData("New Deaths", widget.newDeaths, Color(0xffFFA32F)),
      new GlobalData("New Recovered", widget.newRecovered, Color(0xffF17CB0)),
            new GlobalData(
          "Total Recovered", widget.totalRecovered, Color(0xff60BD68)),
      new GlobalData(
          "Total Confirmed", widget.totalConfirmed, Color(0xff5DA5DA)),
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
    return Consumer<Store>(
        builder: (context, store, child) {
    return Scaffold(
        body: charts.PieChart(
          _seriesPieData,
          animate: true,

          animationDuration: Duration(seconds: 1),
          behaviors: [
            new charts.DatumLegend(
              outsideJustification: charts.OutsideJustification.endDrawArea,
              horizontalFirst: false,
              desiredMaxRows: 3,
              cellPadding:
                  new EdgeInsets.only(top: 4, right: 4, bottom: 4),
              entryTextStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.black, fontSize: 14),
            ),
          ],
          defaultRenderer: new charts.ArcRendererConfig(
              arcWidth: 100,
               startAngle: 6.5/ 5 * 3.14,
              arcRendererDecorators: [
                new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.auto,
                  showLeaderLines: true
                )
              ]),
        ));
        },
      );
  }
}
