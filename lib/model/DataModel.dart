import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization/localization.dart';
import 'package:csv/csv.dart';

import '/model/Model.dart';
import '/model/DataRowModel.dart';

class DataModel extends Model {
  Future? loadDataFromFile(csvFilePath) async {
    //load file here
    final rawData = await rootBundle.loadString(csvFilePath);
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);

    if (listData.length <= 0) {
      return false;
    }
    //process data here

    //assuming first row as title
    Map<String, int> header = {};
    listData[0].asMap().forEach((index, node) {
      header[node as String] = index;
    });

    //await setSharedPref('fields', header, type: 'list');
    listData.removeAt(0);
    return {"data": listData, "fields": header};
  }

  getFilterData(data, filter, filterValues) {
    Map<String, int> compile = {};
    Map<String, String> map = {};
    List<List<dynamic>> filtered_data = [];
    int total = 0;
    data.forEach((node) {
      if (filter != null && node[filter] == null) {
        return;
      }
      bool isFiltered = false;

      filterValues.forEach((f, v) {
        if (isFiltered) return;
        if (node[f] == null) {
          return;
        }
        if (v.toString() != node[f].toString()) {
          isFiltered = true;
        }
      });
      if (isFiltered) return;
      filtered_data.add(node);
      if (filter != null) {
        String code = node[filter].toString();
        map[code] = code;
        if (compile[code] == null) compile[code] = 0;
        compile[code] = (compile[code]! + 1);
      }
      total = total + 1;
    });
    List<DataRowModel> ret = [];
    compile.forEach((index, node) {
      ret.add(DataRowModel(index, node));
    });
    return {"data": ret, "map": map, "total": total, 'filtered': filtered_data};
  }
}
