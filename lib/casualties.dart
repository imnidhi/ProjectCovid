import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CountryData.dart';
import 'LineGraph.dart';
import 'Store.dart';

class Casualties extends StatefulWidget {
  @override
  _CasualtiesState createState() => _CasualtiesState();
}

class _CasualtiesState extends State<Casualties> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(
      builder: (context, store, child) {
        if (store.countryDataList.isEmpty) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent)));
        } else {
          return Scaffold(
              appBar: AppBar(
                title: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: FittedBox(
                                                  child: Text(
                            "% CHANGE IN DEATH RATE OVER LAST 30 DAYS",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "20 Most Affected Countries",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red[100],
              ),
              body: GridView.builder(
                  itemCount: store.deaths.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          List<GlobalData> data = store.getDataForLineGraph(
                              store.deaths[index]['Country']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Line(
                                    "Deaths",
                                    store.deaths[index]['Country'],
                                    data.sublist(
                                        data.length - 30, data.length)),
                              ));
                        },
                        child: Container(
                          child: Stack(
                            children: <Widget>[
                              Flags.getMiniFlag(
                                  "${store.deaths[index]['ISO']}", 300, 200),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: SizedBox(
                                  height: 40,
                                  width: 60,
                                  child: new ClipOval(
                                    child: Material(
                                        color: Colors.black,
                                        child: Center(
                                          child: Text(
                                            "${store.deaths[index]['rateOfDeaths']}%",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Text(
                                  "${store.deaths[index]['Country']}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }));
        }
      },
    );
  }
}
