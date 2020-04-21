import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
    _getGlobalSummary();
  }

  void _getGlobalSummary() {
    var pieData = [
      new GlobalData(
          "Total Confirmed", widget.totalConfirmed, Color(0xff18b0b0)),
      new GlobalData("New Confirmed", widget.newConfirmed, Color(0xff8CDCCB)),
      new GlobalData("Total Deaths", widget.totalDeaths, Colors.red[900]),
      new GlobalData("New Deaths", widget.newDeaths, Color(0xffEE7854)),
      new GlobalData(
          "Total Recovered", widget.totalRecovered, Color(0xffB2D95A)),
      new GlobalData("New Recovered", widget.newRecovered, Color(0xffF7C24F)),
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
    return Scaffold(
        body: Stack(
      children: <Widget>[
        charts.PieChart(
          _seriesPieData,
          animate: true,
          animationDuration: Duration(seconds: 1),
          behaviors: [
            new charts.DatumLegend(
              outsideJustification: charts.OutsideJustification.endDrawArea,
              horizontalFirst: false,
              desiredMaxRows: 3,
              cellPadding: new EdgeInsets.only(top: 16, right: 4, bottom: 4),
              entryTextStyle: charts.TextStyleSpec(
                  color: charts.MaterialPalette.white, fontSize: 12),
            ),
          ],
          defaultRenderer: new charts.ArcRendererConfig(
              arcWidth: 100,
              arcRendererDecorators: [
                new charts.ArcLabelDecorator(
                    labelPosition: charts.ArcLabelPosition.inside)
              ]),
        ),
      ],
    ));
  }
}
