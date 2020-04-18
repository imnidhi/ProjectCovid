import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Store.dart';
import 'casualties.dart';
import 'recovery.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => Store()),
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
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
            .getCountryDataFromSharedPref();
        print("Stored");
      });
    } else {
      print("Data exists");
      Provider.of<Store>(context, listen: false).getCountryDataFromSharedPref();
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
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
              tabs: [
                Tab(child: Text("RECOVERY")),
                Tab(child: Text("DEATH")),
              ],
            ),
            title: Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [Recovery(), Casualties()],
          ),
        ),
      ),
    );
  }
}
