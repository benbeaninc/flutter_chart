import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import '/model/ShoppingModel.dart';
import '/model/DataRowModel.dart';
//import 'package:pie_chart/pie_chart.dart';
import '/element/input/dialog.dart';
import '/element/chart/verticalChart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class Datatable extends StatefulWidget {
  List<List<dynamic>> data = [];
  Map<String, int> fields = {};
  Datatable(
    this.data,
    this.fields, {
    super.key,
  });

  @override
  State<Datatable> createState() => _Datatable();
}

class _Datatable extends State<Datatable> {
  @override
  List<DataColumn> getColumns() {
    List<DataColumn> ret = [];
    widget.fields.forEach((title, value) {
      ret.add(DataColumn(
        label: Expanded(
          child: Text(
            title,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ));
    });
    return ret;
  }

  List<DataRow> getData() {
    List<DataRow> ret = [];
    widget.data.forEach((row) {
      if (ret.length > 10) return;
      List<DataCell> dataRow = [];
      row.forEach((value) {
        dataRow.add(DataCell(Text(value.toString())));
      });
      ret.add(
        DataRow(cells: dataRow),
      );
    });

    return ret;
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: getColumns(),
          rows: getData(),
        ),
      ),
    );
  }
}
