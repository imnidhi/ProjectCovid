import 'dart:convert';
import 'package:country_pickers/country_pickers.dart';
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
    {"Country": "United States", "Slug": "united-states", "ISO2": "US"},
    {"Country": "Italy", "Slug": "italy", "ISO2": "IT"},
    {"Country": "Spain", "Slug": "spain", "ISO2": "ES"},
    {"Country": "Germany", "Slug": "germany", "ISO2": "DE"},
    {"Country": "China", "Slug": "china", "ISO2": "CN"},
    {"Country": "France", "Slug": "france", "ISO2": "FR"},
    {"Country": "Iran, Islamic Republic of", "Slug": "iran", "ISO2": "IR"},
    {"Country": "United Kingdom", "Slug": "united-kingdom", "ISO2": "GB"},
    {"Country": "Turkey", "Slug": "turkey", "ISO2": "TR"},
    {"Country": "Japan", "Slug": "japan", "ISO2": "JP"},
    {"Country": "Australia", "Slug": "australia", "ISO2": "AU"},
    {"Country": "Brazil", "Slug": "brazil", "ISO2": "BR"},
    {"Country": "Saudi Arabia", "Slug": "saudi-arabia", "ISO2": "SA"},
    {"Country": "Portugal", "Slug": "portugal", "ISO2": "PT"},
    {"Country": "Peru", "Slug": "peru", "ISO2": "PE"},
    {"Country": "Belgium", "Slug": "belgium", "ISO2": "BE"},
    {"Country": "Canada", "Slug": "canada", "ISO2": "CA"},
    {"Country": "Russian Federation", "Slug": "russia", "ISO2": "RU"},
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
                  val.countryDataList[val.countryDataList.length - 30]
                      .recovered) *
              100) /
          val.countryDataList.last.recovered;
      double rateOfDeath = ((val.countryDataList.last.deaths -
                  val.countryDataList[val.countryDataList.length - 3].deaths) *
              100) /
          val.countryDataList.last.deaths;

      var country;
      try {
        country = CountryPickerUtils.getCountryByName(key);
      } catch (Exception) {
        print("Country code not available");
      }
      recovered.add({
        "Country": key,
        "ISO": country != null ? country.isoCode : "",
        "rateOfRecovery": rateOfRecovery.round()
      });
      deaths.add({
        "Country": key,
        "ISO": country != null ? country.isoCode : "",
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
      http.Response response = await http
          .get("https://api.covid19api.com/total/country/${country['Slug']}");
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
    print(summary);
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
    return dataPoints;
  }

  List<double> getDataPointsForDeaths(String countryName) {
    List<double> dataPoints = [];
    for (CountryData data in countryDataList[countryName].countryDataList) {
      dataPoints.add(data.deaths.toDouble());
    }
    return dataPoints;
  }
}
