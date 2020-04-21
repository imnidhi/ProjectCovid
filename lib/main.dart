import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        scaffoldBackgroundColor: Colors.grey[600]
      ),
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
  @override
  void initState() {
    super.initState();
    checkIfDataExists();
  }

  void checkIfDataExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('Country') == null) {
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
      print("Data exists");
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
        length: 2,
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
                Tab(child: Text("RATE OF RECOVERY FOR LAST 30 DAYS")),
                Tab(child: Text("RATE OF DEATH FOR LAST 30 DAYS")),
              ],
            ),
            title: Text('COVID-19'),
          ),
          body: TabBarView(
            children: [Recovery(), Casualties()],
          ),
        ),
      ),
    );
  }
}
