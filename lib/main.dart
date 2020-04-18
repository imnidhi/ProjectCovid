import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:project_covid/CountryData.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Store.dart';
import 'casualties.dart';
import 'recovery.dart';
import 'package:intl/intl.dart';

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
      getCountryData().then((v) {
        print("Data Fetched");
         Provider.of<Store>(context, listen: false).getCountryDataFromSharedPref();
         print("Stored");
      });
    } else {
      print("Data exists");
    }
  }

  static DateTime today = new DateTime.now();
  static DateTime daysAgo = today.subtract(new Duration(days: 15));
  var todaysDate = new DateFormat("yyyy-MM-dd").format(today);
  var thirtydaysago = new DateFormat("yyyy-MM-dd").format(daysAgo);

  // Future<List> getCountries() async {
  //   http.Response response =
  //       await http.get("https://api.covid19api.com/countries");
  //   countries = json.decode(response.body);
  //   return countries;
  // }

  Future<void> getCountryData() async {
    Map<String, String> countryDataForThirtyDays = {};
    print("QUERY 2");
    int i = 0;
    for (var country in Provider.of<Store>(context, listen: false).countries) {
      print(i);
      i++;
      http.Response response = await http.get(
          "https://api.covid19api.com/country/${country['Slug']}?from=${thirtydaysago}T00:00:00Z&to=${todaysDate}T00:00:00Z");
      try {
        print(response.body);
        countryDataForThirtyDays[country['Country']] = response.body;
      } catch (Exception) {
        continue;
      }
    }
    Provider.of<Store>(context, listen: false)
        .setCountryData('Country', json.encode(countryDataForThirtyDays));
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
