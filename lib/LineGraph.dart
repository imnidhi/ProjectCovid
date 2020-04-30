import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'CountryData.dart';
import 'Store.dart';
import 'CustomToolTipForGraph.dart';

class Line extends StatefulWidget {
  String state;
  String countryName;
  List<GlobalData> dataPoints;
  Line(this.state, this.countryName, this.dataPoints);

  @override
  _LineState createState() => _LineState();
}

class _LineState extends State<Line> {
  List<charts.Series<GlobalData, DateTime>> _seriesPieData;
  @override
  void initState() {
    super.initState();
    _seriesPieData = List<charts.Series<GlobalData, DateTime>>();
    dataForLine();
  }

  void dataForLine() {
    var lineData = widget.dataPoints;
    _seriesPieData.add(charts.Series(
        data: lineData,
        domainFn: (GlobalData data, _) => data.date,
        measureFn: (GlobalData data, _) =>
            widget.state == 'Recovery' ? data.noOfRecoveries : data.noOfDeaths,
        id: "Global COVID-19 Data",
        labelAccessorFn: (GlobalData row, _) => widget.state == 'Recovery'
            ? '${row.noOfRecoveries}'
            : '${row.noOfDeaths}'));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(
      builder: (context, store, child) {
        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      widget.countryName.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      letterSpacing: 4, fontSize: 30, color: Colors.white),
                    ),
                  ),
                  widget.state == "Recovery"
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Latest Recoveries: " +
                                    widget.dataPoints.last.noOfRecoveries
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Recoveries 30 days ago: " +
                                    widget.dataPoints[0].noOfRecoveries
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Latest Deaths: " +
                                    widget.dataPoints.last.noOfDeaths
                                        .toString(),
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Deaths 30 days ago: " +
                                    widget.dataPoints[0].noOfDeaths.toString(),
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: charts.TimeSeriesChart(
                        _seriesPieData,
                        animate: true,
                        animationDuration: Duration(seconds: 1),
                        defaultRenderer: new charts.LineRendererConfig(
                          includePoints: true,
                        ),
                        domainAxis: new charts.DateTimeAxisSpec(
                            renderSpec: new charts.SmallTickRendererSpec(
                                labelStyle: new charts.TextStyleSpec(
                                    fontSize: 18,
                                    color: charts.MaterialPalette.white),
                                lineStyle: new charts.LineStyleSpec(
                                    color: charts.MaterialPalette.white))),
                        primaryMeasureAxis: new charts.NumericAxisSpec(
                            renderSpec: new charts.GridlineRendererSpec(
                                labelStyle: new charts.TextStyleSpec(
                                    fontSize: 18,
                                    color: charts.MaterialPalette.white),
                                lineStyle: new charts.LineStyleSpec(
                                    color: charts.MaterialPalette.white))),
                        selectionModels: [
                          charts.SelectionModelConfig(
                              changedListener: (charts.SelectionModel model) {
                            if (model.hasDatumSelection) {
                              ToolTipMgr.setTitle({
                                'title':
                                    '${DateFormat("MMM-dd").format(model.selectedSeries[0].domainFn(model.selectedDatum[0].index))}\nCases: ${model.selectedSeries[0].measureFn(model.selectedDatum[0].index)}',
                              });
                            }
                          })
                        ],
                        behaviors: [
                          new charts.LinePointHighlighter(
                              symbolRenderer: CustomCircleSymbolRenderer()),
                          new charts.SelectNearest(
                              eventTrigger: charts.SelectionTrigger.tapAndDrag),
                          new charts.ChartTitle('Dates',
                              titleStyleSpec: charts.TextStyleSpec(
                                  color: charts.MaterialPalette.white),
                              behaviorPosition: charts.BehaviorPosition.bottom,
                              titleOutsideJustification:
                                  charts.OutsideJustification.middleDrawArea),
                          new charts.ChartTitle('Number of cases',
                              titleStyleSpec: charts.TextStyleSpec(
                                  color: charts.MaterialPalette.white),
                              behaviorPosition: charts.BehaviorPosition.start,
                              titleOutsideJustification:
                                  charts.OutsideJustification.middleDrawArea)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
