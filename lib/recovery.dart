import 'package:flutter/material.dart';
import 'package:project_covid/CountryData.dart';
import 'package:project_covid/Store.dart';
import 'package:provider/provider.dart';
import 'package:flag/flag.dart';
import 'LineGraph.dart';

class Recovery extends StatefulWidget {
  @override
  _RecoveryState createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(
      builder: (context, store, child) {
        if (store.countryDataList.isEmpty) {
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ));
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
                            "CHANGE IN RECOVERY RATE OVER LAST 30 DAYS",
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
                  itemCount: store.recovered.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          List<GlobalData> data = store.getDataForLineGraph(
                              store.recovered[index]['Country']);
                          print("AAAAAAAAAAAAAAAAAAA");
                          print(data);
                          print(data.sublist(data.length - 30, data.length));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Line(
                                      "Recovery",
                                      store.recovered[index]['Country'],
                                      data.sublist(
                                          data.length - 30, data.length))));
                        },
                        child: Container(
                          child: Stack(
                            children: <Widget>[
                              store.recovered[index]['ISO'] == ""
                                  ? Container(
                                      height: 100,
                                      width: 200,
                                      child: Center(
                                        child: Text(store.recovered[index]
                                                ['Country']
                                            .toString()
                                            .toUpperCase()),
                                      ),
                                      color: Colors.white,
                                    )
                                  : Flags.getMiniFlag(
                                      "${store.recovered[index]['ISO']}",
                                      300,
                                      200),
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
                                            "${store.recovered[index]['rateOfRecovery']}%",
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
