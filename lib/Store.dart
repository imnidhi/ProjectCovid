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
  Map<String, CountryDataList> countryDataList={};

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
    print(countryData);
    print(countryDataList);
    notifyListeners();
  }
}
