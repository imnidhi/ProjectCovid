import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Raleway',
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.black),
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
  Timer timer;
  @override
  void initState() {
    super.initState();
    checkIfDataExists();
    Provider.of<Store>(context, listen: false).checkifGlobalDataExists();
    timer = Timer.periodic(Duration(hours: 4), (Timer t) {
      checkIfDataExists();
    });
    timer = Timer.periodic(Duration(hours: 4), (Timer t) {
      Provider.of<Store>(context, listen: false).checkifGlobalDataExists();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void checkIfDataExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(DateTime.now().difference(DateTime.parse(prefs.getString('date'))).inHours);
    if (prefs.getString('Country') == null ||
        DateTime.now()
                .difference(DateTime.parse(prefs.getString('date')))
                .inHours >=
            4) {
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
              endDrawer: Drawer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: <Widget>[
                        DrawerHeader(
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'Useful Links',
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 20),
                              )),
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 10, right: 10),
                          child: new InkWell(
                              child: FittedBox(
                                  child: new Text(
                                'WORLD HEALTH ORGANISATION',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              )),
                              onTap: () async {
                                String url =
                                    "https://www.who.int/emergencies/diseases/novel-coronavirus-2019";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: new InkWell(
                              child: new Text(
                                'CDC',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () async {
                                String url =
                                    "https://www.cdc.gov/coronavirus/2019-ncov/index.html";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: new InkWell(
                              child: new Text(
                                'NHS',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () async {
                                String url =
                                    "https://www.nhs.uk/conditions/coronavirus-covid-19/";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: new InkWell(
                              child: new Text(
                                'GOOGLE NEWS',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () async {
                                String url =
                                    "https://news.google.com/topstories?hl=en-IN&gl=IN&ceid=IN:en";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40.0, right: 10, left: 10),
                          child: new InkWell(
                              child: FittedBox(
                                child: new Text(
                                  'GOOGLE INFO and RESOURCES',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                              onTap: () async {
                                String url =
                                    "https://www.google.com/intl/en_in/covid19/";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: new InkWell(
                              child: new Text(
                                'MoHFW India',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () async {
                                String url = "https://www.mohfw.gov.in/#";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        color: Colors.grey[600],
                        child: Column(
                          children: [
                            Text(
                              "Sources",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text("Postman COVID-19 API Resource Center",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              appBar: AppBar(
                // leading: GestureDetector(
                //   onTap: () {
                //     Provider.of<Store>(context, listen: false)
                //         .clearDataInSharedPref();
                //   },
                //   child: Icon(
                //     Icons.clear,
                //   ),
                // ),
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  unselectedLabelColor: Colors.redAccent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.redAccent),
                  tabs: [
                    Tab(child: Text("TOTAL")),
                    Tab(child: Container(child: Text("MAP"))),
                    Tab(child: Center(child: Text("RECOVERY"))),
                    Tab(child: Text("DEATHS")),
                  ],
                ),
                title: Text('COVID 19 STATS'),
              ),
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Consumer<Store>(
                    builder: (context, store, child) {
                      if (store.summary['Global'] == null) {
                        return Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.redAccent)));
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
