import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import '/model/ShoppingModel.dart';
import '/model/DataRowModel.dart';
//import 'package:pie_chart/pie_chart.dart';
import '/element/input/dialog.dart';
import '/element/chart/verticalChart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class Chart extends StatefulWidget {
  List<List<dynamic>> data = [];
  Map<String, int> fields = {};
  Map<String, String> categoryMap = {};
  late List<DataRowModel> filterData;
  String? filter = "";
  Map<int, String> filterValues = {};
  final Function? onTap;
  late int totalRecords;
  int maxPiechart = 6;
  int minHorchart = 10;

  Chart(
    this.data,
    this.fields,
    this.filter,
    this.filterValues, {
    super.key,
    this.onTap,
  });

  @override
  State<Chart> createState() => _Chart();
}

class _Chart extends State<Chart> {
  @override
  List<charts.Series<DataRowModel, String>> getChartData() {
    if (widget.fields[widget.filter] == null) {
      return [];
    }
    //return [];
    int filterIdx = widget.fields[widget.filter]!;

    var filterData = ShoppingModel()
        .getFilterData(widget.data, filterIdx, widget.filterValues);
    if (filterData["data"] == null || filterData["map"] == null) return [];

    setState(() {
      widget.categoryMap = filterData["map"];
      widget.filterData = filterData["data"];
      widget.totalRecords = filterData["total"] ?? 0;
    });
    int categoryCnt = widget.categoryMap.length;

    return [
      charts.Series<DataRowModel, String>(
        id: widget.filter ?? "nothing",
        domainFn: (DataRowModel row, _) => row.category,
        measureFn: (DataRowModel row, _) => row.count,
        data: filterData["data"],
        labelAccessorFn: (DataRowModel row, _) {
          if (categoryCnt < widget.maxPiechart) {
            return '${row.category}: ${NumberFormat.decimalPattern('en').format(row.count)}';
          }
          return NumberFormat.decimalPattern('en').format(row.count);
        },
      )
    ];
  }

  Widget getChart() {
    List<charts.Series<DataRowModel, String>> dataMap = getChartData();
    int categoryCnt = widget.categoryMap.length;
    if (categoryCnt > widget.minHorchart) {
      return VerticalChart(
        data: widget.filterData,
        map: widget.categoryMap,
        onTap: (value) {
          if (widget.totalRecords > 1 && widget.onTap != null) {
            widget.onTap!(widget.filter, value);
          }
        },
      );
    }
    if (categoryCnt == 0) {
      return Text(
        "no-data-found".i18n(),
        style: const TextStyle(color: Color.fromARGB(93, 101, 101, 101)),
      );
    }
    if (categoryCnt < widget.maxPiechart) {
      return charts.PieChart<String>(
        dataMap,
        animate: true,
        defaultRenderer: charts.ArcRendererConfig(arcRendererDecorators: [
          charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.inside)
        ]),
        selectionModels: [
          if (widget.totalRecords > 1)
            charts.SelectionModelConfig(
              changedListener: (model) {
                String selectedValue = model.selectedSeries[0]
                    .domainFn(model.selectedDatum[0].index);

                if (widget.onTap != null) {
                  widget.onTap!(widget.filter, selectedValue);
                }
              },
            )
        ],
      );
    }
    return charts.BarChart(
      dataMap,
      animate: true,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: const charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          // Rotation Here,
          labelRotation: 45,
        ),
      ),
      selectionModels: [
        if (widget.totalRecords > 1)
          charts.SelectionModelConfig(
            changedListener: (model) {
              String selectedValue = model.selectedSeries[0]
                  .domainFn(model.selectedDatum[0].index);

              if (widget.onTap != null) {
                widget.onTap!(widget.filter, selectedValue);
              }
            },
          )
      ],
    );
  }

  Widget getTotalText() {
    if (widget.data.length == widget.totalRecords) {
      return Text(
          "total-record".i18n([
            NumberFormat.decimalPattern('en').format(widget.data.length),
          ]),
          style: const TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
            fontSize: 11,
          ));
    }
    return Text(
        "total-record2".i18n([
          NumberFormat.decimalPattern('en').format(widget.totalRecords),
          NumberFormat.decimalPattern('en').format(widget.data.length)
        ]),
        style: const TextStyle(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
          fontSize: 11,
        ));
  }

  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: getChart(),
      ),
      if (widget.totalRecords <= 1)
        Padding(
            padding: const EdgeInsets.all(3),
            child: Text("nothing-to-click".i18n(),
                style: const TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                  fontSize: 11,
                ))),
      Padding(
        padding: const EdgeInsets.all(3),
        child: Align(
          alignment: Alignment.bottomRight,
          child: getTotalText(),
        ),
      )
    ]);
  }
}
