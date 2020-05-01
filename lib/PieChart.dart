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
       new GlobalData("New Confirmed", widget.newConfirmed, Color(0xffF1BF98)),
      new GlobalData(
          "Total Confirmed", widget.totalConfirmed, Color(0xff7FC6A4)),
      new GlobalData(
          "Total Recovered", widget.totalRecovered, Color(0xffA6979C)),
      new GlobalData("New Recovered", widget.newRecovered, Color(0xffFFFC99)),
      new GlobalData("New Deaths", widget.newDeaths, Color(0xff333232)),
      new GlobalData("Total Deaths", widget.totalDeaths, Color(0xffBACBA9)),
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
            body: Stack(
          children: [
            charts.PieChart(
              _seriesPieData,
              animate: true,
              animationDuration: Duration(milliseconds: 500),
              behaviors: [
                new charts.DatumLegend(
                  outsideJustification: charts.OutsideJustification.endDrawArea,
                  horizontalFirst: false,
                  desiredMaxRows: 3,
                  cellPadding: new EdgeInsets.only(top: 4, right: 4, bottom: 4),
                  entryTextStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.white, fontSize: 14),
                ),
              ],
              defaultRenderer: new charts.ArcRendererConfig(
                  arcWidth: 100,
                  strokeWidthPx: 0,
                  startAngle: 7.2 / 5 * 3.14,
                  arcRendererDecorators: [
                    new charts.ArcLabelDecorator(
                        labelPosition: charts.ArcLabelPosition.auto,
                        outsideLabelStyleSpec: charts.TextStyleSpec(
                          color: charts.Color.white,
                          fontSize: 12,
                        ))
                  ]),
            ),
          ],
        ));
      },
    );
  }
}
