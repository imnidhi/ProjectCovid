import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Store.dart';

class Casualties extends StatefulWidget{
  @override
  _CasualtiesState createState() => _CasualtiesState();
}

class _CasualtiesState extends State<Casualties> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Store>(
      builder: (context, store, child) {
        return Scaffold(
            body: new GridView.builder(
                itemCount: store.countries.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Stack(
                        children: <Widget>[
                          Flags.getFullFlag("${store.countries[index]['ISO2']}",300,200),
                           Center(child: Text("${store.countries[index]['Country']}")),
                        ],
                      ),
                      color: Colors.green[100],
                    ),
                  );
                }));
      },
    );
  }
}