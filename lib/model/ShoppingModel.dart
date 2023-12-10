import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '/model/DataModel.dart';

class ShoppingModel extends DataModel {
  final String csvFilePath = 'assets/data/shopping_trends.csv';
  String firstFilter() {
    return "Item Purchased";
  }

  bool checkBlackListFilter(filter) {
    List<String> list = ["Customer ID"];
    if (list.contains(filter)) return true;
    return false;
  }

  Future? loadData() async {
    return loadDataFromFile(csvFilePath);
  }
}
