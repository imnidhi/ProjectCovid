import 'package:flutter/material.dart';
import 'package:project_covid/Maps.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'PieChart.dart';
import 'Store.dart';
import 'casualties.dart';
import 'recovery.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => Store(),
      ),
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.white),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var summary = {};
  @override
  void initState() {
    super.initState();
    checkIfDataExists(Provider.of<Store>(context, listen: false).todaysDate);
    Provider.of<Store>(context, listen: false).checkifGlobalDataExists();
  }

  void checkIfDataExists(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('Country') == null || date!=prefs.getString('date')) {
      Provider.of<Store>(context, listen: false).getCountryData().then((v) {
        print("Data Fetched");
        Provider.of<Store>(context, listen: false)
            .getCountryDataFromSharedPref()
            .then((onValue) {
          Provider.of<Store>(context, listen: false)
              .calculateRecoveryandDeathRate();
        });
        print("Stored");
      });
    } else {
      Provider.of<Store>(context, listen: false)
          .getCountryDataFromSharedPref()
          .then((onValue) {
        Provider.of<Store>(context, listen: false)
            .calculateRecoveryandDeathRate();
      });
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                leading: GestureDetector(
                  onTap: () {
                    Provider.of<Store>(context, listen: false)
                        .clearDataInSharedPref();
                  },
                  child: Icon(
                    Icons.clear,
                  ),
                ),
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(child: Text("TOTAL")),
                    Tab(child: Text("MAP")),
                    Tab(child: Text("RECOVERY")),
                    Tab(child: Text("DEATH")),
                  ],
                ),
                title: Text('COVID-19'),
              ),
              body: TabBarView(
                children: [
                  Consumer<Store>(
                    builder: (context, store, child) {
                      if (store.summary['Global'] == null) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return PieChart(
                            store.summary['Global']['TotalConfirmed'],
                            store.summary['Global']['NewConfirmed'],
                            store.summary['Global']['TotalDeaths'],
                            store.summary['Global']['NewDeaths'],
                            store.summary['Global']['TotalRecovered'],
                            store.summary['Global']['NewRecovered']);
                      }
                    },
                  ),
                  Maps(),
                  Recovery(),
                  Casualties()
                ],
              ),
            )));
  }
}
