import 'dart:convert';
import 'package:flag/flag.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CountryData.dart';

class Store with ChangeNotifier {
  static DateTime today = new DateTime.now();
  static DateTime daysAgo = today.subtract(new Duration(days: 30));
  var todaysDate = new DateFormat("yyyy-MM-dd").format(today);
  var thirtydaysago = new DateFormat("yyyy-MM-dd").format(daysAgo);
  Map<String, CountryDataList> countryDataList = {};
  List recovered = [];
  List deaths = [];
  List<Marker> allMarkers = [];
  Map<String, dynamic> summary = {};
  List countries = [
    {"Country": "Switzerland", "Slug": "switzerland", "ISO2": "CH"},
    {"Country": "India", "Slug": "india", "ISO2": "IN"},
    {
      "Country": "United States of America",
      "Slug": "united-states",
      "ISO2": "US"
    },
     {"Country": "Italy", "Slug": "italy", "ISO2": "IT"},
    // {"Country": "Spain", "Slug": "spain", "ISO2": "ES"},
    // {"Country": "Germany", "Slug": "germany", "ISO2": "DE"},
    // {"Country": "China", "Slug": "china", "ISO2": "CN"},
    // {"Country": "France", "Slug": "france", "ISO2": "FR"},
    // {"Country": "Iran", "Slug": "iran", "ISO2": "IR"},
    // {"Country": "United Kingdom", "Slug": "united-kingdom", "ISO2": "GB"},
    // {"Country": "Turkey", "Slug": "turkey", "ISO2": "TR"},
  ];

  // Future<List> getCountries() async {
  //   http.Response response =
  //       await http.get("https://api.covid19api.com/countries");
  //   countries = json.decode(response.body);
  //   return countries;
  // }
  void calculateRecoveryandDeathRate() {
    countryDataList.forEach((key, val) {
      double rateOfRecovery = ((val.countryDataList.last.recovered -
                  val.countryDataList[0].recovered) *
              100) /
          val.countryDataList.last.recovered;
      double rateOfDeath =
          ((val.countryDataList.last.deaths - val.countryDataList[0].deaths) *
                  100) /
              val.countryDataList.last.deaths;
      recovered.add({
        "Country": key,
        "ISO": val.countryDataList[0].countryCode,
        "rateOfRecovery": rateOfRecovery.round()
      });
      deaths.add({
        "Country": key,
        "ISO": val.countryDataList[0].countryCode,
        "rateOfDeaths": rateOfDeath.round()
      });
    });
    recovered
        .sort((a, b) => a['rateOfRecovery'].compareTo(b['rateOfRecovery']));
    recovered = recovered.reversed.toList();
    deaths.sort((a, b) => a['rateOfDeaths'].compareTo(b['rateOfDeaths']));
    deaths = deaths.reversed.toList();

    notifyListeners();
  }

  Future<void> getCountryData() async {
    Map<String, String> countryDataForThirtyDays = {};
    print("QUERY 2");
    for (var country in countries) {
      http.Response response = await http.get(
          "https://api.covid19api.com/live/country/${country['Slug']}/status/confirmed/date/${thirtydaysago}T13:13:30Z");
      print(response.body);
      try {
        countryDataForThirtyDays[country['Country']] = response.body;
      } catch (Exception) {
        continue;
      }
    }
    setCountryData('Country', json.encode(countryDataForThirtyDays));
  }

  Future<void> getGlobalSummary() async {
    http.Response response =
        await http.get("https://api.covid19api.com/summary");
    setGlobalDataToSharedPrefs(response.body);
  }

  void setGlobalDataToSharedPrefs(String globalData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('globalData', globalData);
    prefs.setString('date', DateFormat("yyyy-MM-dd").format(DateTime.now()));
  }

  Future<void> getGlobalDataFromSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    summary = json.decode(prefs.getString('globalData'));
    notifyListeners();
  }

  Future<dynamic> checkifGlobalDataExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('globalData') == null ||
        prefs.getString('date') != todaysDate) {
      getGlobalSummary().then((onValue) {
        getGlobalDataFromSharedPrefs();
      });
    } else {
      getGlobalDataFromSharedPrefs();
    }
  }

  void setCountryData(String countryName, String countryDataMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(countryName, countryDataMap);
  }

  void clearDataInSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> getCountryDataFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, CountryDataList> countryData = {};
    var countryDataMap = json.decode(prefs.getString('Country'));
    countryDataMap.forEach((country, jsonList) {
      countryData[country] = CountryDataList.fromJson(jsonDecode(jsonList));
    });
    countryDataList = countryData;
    // print(countryDataList["United States of America"].countryDataList.last.);
    notifyListeners();
  }

  List<GlobalData> getDataForLineGraph(String countryName) {
    List<GlobalData> dataList = [];
    for (CountryData data in countryDataList[countryName].countryDataList) {
      dataList.add(
          GlobalData(DateTime.parse(data.date), data.recovered, data.deaths));
    }
    return dataList;
  }

  List<double> getDataPointsForRecovery(String countryName) {
    List<double> dataPoints = [];
    for (CountryData data in countryDataList[countryName].countryDataList) {
      dataPoints.add(data.recovered.toDouble());
    }
    print(dataPoints);
    return dataPoints;
  }

  List<double> getDataPointsForDeaths(String countryName) {
    List<double> dataPoints = [];
    for (CountryData data in countryDataList[countryName].countryDataList) {
      dataPoints.add(data.deaths.toDouble());
    }
    print(dataPoints);
    return dataPoints;
  }

  Widget onclick() {
    return Container(child: Text("hiiiiiiiiii"));
  }

  void _settingModalBottomSheet(context, String title, int confirmed,
      int recovered, int deaths, String code) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.grey[200],
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title.toUpperCase(),
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text("Confirmed Cases: $confirmed",
                              style: TextStyle(fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text("Recovered Cases: $recovered",
                              style: TextStyle(fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text("Deaths: $deaths",
                              style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Flags.getMiniFlag(
                          "$code",
                          MediaQuery.of(context).size.height * 0.1,
                          MediaQuery.of(context).size.height * 0.1),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void getAllMarkers(BuildContext context) {
    countryDataList.forEach((key, value) {
      print(value.countryDataList[0]);
      allMarkers.add(Marker(
          markerId: MarkerId(key),
          draggable: false,
          position: LatLng(double.parse(value.countryDataList[0].lat),
              double.parse(value.countryDataList[0].lon)),
          onTap: () {
            print(key);
            _settingModalBottomSheet(
                context,
                key,
                value.countryDataList.last.confirmed,
                value.countryDataList.last.recovered,
                value.countryDataList.last.deaths,
                value.countryDataList.last.countryCode);
          }));
    });
    notifyListeners();
  }
}
