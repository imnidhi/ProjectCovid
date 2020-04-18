import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CountryData.dart';

class Store with ChangeNotifier {
  static DateTime today = new DateTime.now();
  static DateTime daysAgo = today.subtract(new Duration(days: 15));
  var todaysDate = new DateFormat("yyyy-MM-dd").format(today);
  var thirtydaysago = new DateFormat("yyyy-MM-dd").format(daysAgo);
  Map<String, CountryDataList> countryDataList = {};
  List recoveries = [];
  List casualties = [];
  List countries = [
    {"Country": "Switzerland", "Slug": "switzerland", "ISO2": "CH"},
    {"Country": "India", "Slug": "india", "ISO2": "IN"},
  ];

  
  // Future<List> getCountries() async {
  //   http.Response response =
  //       await http.get("https://api.covid19api.com/countries");
  //   countries = json.decode(response.body);
  //   return countries;
  // }

  Future<void> getCountryData() async {
    Map<String, String> countryDataForThirtyDays = {};
    print("QUERY 2");
    for (var country in countries) {
      http.Response response = await http.get(
          "https://api.covid19api.com/country/${country['Slug']}?from=${thirtydaysago}T00:00:00Z&to=${todaysDate}T00:00:00Z");
      try {
        countryDataForThirtyDays[country['Country']] = response.body;
      } catch (Exception) {
        continue;
      }
    }
    setCountryData('Country', json.encode(countryDataForThirtyDays));
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
}
