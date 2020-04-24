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
        return Scaffold(
          body: Container(
            height: 400,
            child: charts.TimeSeriesChart(
              _seriesPieData,
              animate: true,
              animationDuration: Duration(seconds: 1),
              defaultRenderer: new charts.LineRendererConfig(
                includePoints: true,
              ),
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
                    behaviorPosition: charts.BehaviorPosition.bottom,
                    titleOutsideJustification:
                        charts.OutsideJustification.middleDrawArea),
                new charts.ChartTitle('Number of cases',
                    behaviorPosition: charts.BehaviorPosition.start,
                    titleOutsideJustification:
                        charts.OutsideJustification.middleDrawArea)
              ],
            ),
          ),
        );
      },
    );
  }
}
