import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import '/model/ShoppingModel.dart';
import '/model/DataRowModel.dart';
//import 'package:pie_chart/pie_chart.dart';
import '/element/common.dart';
import '/element/input/dialog.dart';
import '/element/chart/verticalChart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class Datatable extends StatefulWidget {
  List<List<dynamic>> data = [];
  Map<String, int> fields = {};
  Map<int, String> filterValues = {};

  int limit = 10;
  int start = 0;
  bool isEnd = false;
  Datatable(
    this.data,
    this.fields,
    this.filterValues, {
    super.key,
    this.limit = 10,
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
    var filterData =
        ShoppingModel().getFilterData(widget.data, null, widget.filterValues);

    if (filterData["filtered"] == null) return [];
    List<DataRow> ret = [];
    int index = 0;
    var filteredData2 = filterData["filtered"];
    filteredData2.forEach((row) {
      index = index + 1;
      if (widget.start >= index) return;
      if (ret.length >= widget.limit) return;
      List<DataCell> dataRow = [];
      row.forEach((value) {
        dataRow.add(DataCell(Text(value.toString())));
      });
      ret.add(
        DataRow(cells: dataRow),
      );
      if (ret.length < widget.limit) {
        setState(() {
          widget.isEnd = true;
        });
        return;
      }
      if (widget.isEnd == true) {
        setState(() {
          widget.isEnd = false;
        });
      }
    });

    return ret;
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DataTable(
              columns: getColumns(),
              rows: getData(),
            ),
            Row(children: [
              if (widget.start > 0)
                TextButton(
                  onPressed: () {
                    setState(() {
                      widget.start = widget.start - widget.limit;
                      if (widget.start < 0) widget.start = 0;
                    });
                  },
                  child: Text('prev-page'.i18n()),
                ),
              gapW(),
              if (widget.isEnd == false)
                TextButton(
                  onPressed: () {
                    setState(() {
                      widget.start = widget.start + widget.limit;
                    });
                  },
                  child: Text('next-page'.i18n()),
                ),
            ]),
          ],
        ),
      ),
    );
  }
}
