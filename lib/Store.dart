import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CountryData.dart';

class Store with ChangeNotifier {
  List recoveries = [];
  List casualties = [];
  List countries = [
    {"Country": "Switzerland", "Slug": "switzerland", "ISO2": "CH"},
    // {"Country": "India", "Slug": "india", "ISO2": "IN"},
  ];
  Map<String, CountryDataList> countryData = {};

  void setCountryData(String countryName, String countryDataMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(countryName, countryDataMap);
  }

  void clearDataInSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<Map<String, CountryDataList>> getCountryDataFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('Country').runtimeType);
    var countryDataMap = json.decode(prefs.getString('Country'));
    countryDataMap.forEach((country, jsonList) {
      print(jsonDecode(jsonList).runtimeType);
      countryData[country] = CountryDataList.fromJson(jsonDecode(jsonList));
    });
    return countryData;
  }
}
