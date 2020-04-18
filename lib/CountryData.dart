import 'dart:convert';

class CountryData {
  String country;
  String countryCode;
  String lat;
  String lon;
  int confirmed;
  int deaths;
  int recovered;
  int active;
  String date;
  double rateOfRecovery;
  double rateOfDeath;
  CountryData(
      {this.country,
      this.countryCode,
      this.lat,
      this.lon,
      this.confirmed,
      this.deaths,
      this.recovered,
      this.active,
      this.date});

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
        country: json['Country'],
        countryCode: json['CountryCode'],
        lat: json['Lat'],
        lon: json['Lon'],
        confirmed: json['Confirmed'],
        deaths: json['Deaths'],
        recovered: json['Recovered'],
        active: json['Active'],
    
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
