import 'package:flutter/material.dart';
import 'package:project_covid/Store.dart';
import 'package:provider/provider.dart';
import 'package:flag/flag.dart';

class Recovery extends StatefulWidget {
  @override
  _RecoveryState createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(
      builder: (context, store, child) {
        return Scaffold(body: FutureBuilder(
          future: store.getCountryDataFromSharedPref(),
          builder: (context, snapshot) {
            if(snapshot.hasData){

            return new GridView.builder(
                itemCount: store.countries.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Stack(
                        children: <Widget>[
                          Flags.getFullFlag(
                              "${store.countries[index]['ISO2']}", 300, 200),
                          Center(
                              child:
                                  Text("${store.countries[index]['Country']}")),
                        ],
                      ),
                      color: Colors.green[100],
                    ),
                  );
                });
            }
            else{
              return CircularProgressIndicator();
            }
          },
        ));
      },
    );
  }
}
