import 'dart:convert';

class CountryData {
  String country;
  String countryCode;
  String lat;
  String lon;
  int cases;
  String status;
  String date;
  double rateOfRecovery;
  double rateOfDeath;
  CountryData(
      {this.country,
      this.countryCode,
      this.lat,
      this.lon,
      this.cases,
      this.status,
      this.date});

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
        country: json['Country'],
        countryCode: json['CountryCode'],
        lat: json['Lat'],
        lon: json['Lon'],
        cases: json['Cases'],
        status: json['Status'],
        date: json['Date']);
  }
}

class CountryDataList {
  List<CountryData> countryDataList;
  CountryDataList({this.countryDataList});

  factory CountryDataList.fromJson(List countryData) {
    List<CountryData> countryDataList = [];
    for (var cd in countryData) {
      if (cd != null) {
        countryDataList.add(CountryData.fromJson(cd));
      }
    }
    return CountryDataList(countryDataList: countryDataList);
  }
}
