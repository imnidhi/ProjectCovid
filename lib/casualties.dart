import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                  itemCount: store.countryDataList.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    var keys = store.countryDataList.keys.toList();
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Stack(
                          children: <Widget>[
                            Flags.getFullFlag(
                                "${store.countries[index]['ISO2']}", 300, 200),
                            Center(child: Text("${keys[index]}")),
                          ],
                        ),
                        color: Colors.green[100],
                      ),
                    );
                  }));
        }
      },
    );
  }
}
