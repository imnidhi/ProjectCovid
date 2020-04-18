import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Store with ChangeNotifier {
  List recoveries = [];
  List casualties = [];
  List countries = [
    {"Country": "Switzerland", "Slug": "switzerland", "ISO2": "CH"},
    {"Country": "India", "Slug": "india", "ISO2": "IN"},
  ];
}
