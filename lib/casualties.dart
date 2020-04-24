import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:project_covid/Graph.dart';
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
        if (store.countryDataList == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
              body: GridView.builder(
                  itemCount: store.deaths.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    // var keys = store.countryDataList.keys.toList();
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          List<GlobalData> data = store.getDataForLineGraph(store.recovered[index]['Country']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                 builder: (context) => 
                                Line("Deaths",store.recovered[index]['Country'],data),
                            )
                          );
                        
                        },
                        child: Container(
                          child: Stack(
                            children: <Widget>[
                              Flags.getFullFlag(
                                  "${store.deaths[index]['ISO']}", 300, 200),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
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
                                  "${store.recovered[index]['Country']}",
                                  style: TextStyle(color: Colors.white,
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
