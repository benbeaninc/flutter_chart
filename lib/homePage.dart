import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'element/common.dart';
import 'element/loader.dart';
import 'element/chart.dart';
import 'element/Datatable.dart';
import 'element/input/SelectPickerInput.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'element/input/dialog.dart';
import 'model/ShoppingModel.dart';
import 'blankPage.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
    required this.title,
  });
  final String title;
  late String selectedFilter = "";
  late Map<String, int> fields = {};
  late List<String> filters = [];
  late Map<String, String> filterValues = {};
  String viewMode = 'table';

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    Map<String, String> getFilter() {
      Map<String, String> ret = {};
      widget.fields.forEach((f, node) {
        if (widget.filters.contains(f)) return;
        if (ShoppingModel().checkBlackListFilter(f)) return;
        ret[f] = f;
      });
      return ret;
    }

    Map<int, String> getFilterByIndex() {
      Map<int, String> ret = {};
      widget.filterValues.forEach((f, node) {
        if (widget.fields[f]!.isNaN) return;
        int index = widget.fields[f]!;
        ret[index] = node;
      });
      return ret;
    }

    Widget showFilteredList() {
      List<Widget> ret = [];
      widget.filterValues.forEach((f, node) {
        ret.add(Container(
            child: InkWell(
          onTap: () {
            if (widget.filterValues[f] != null) {
              setState(() {
                widget.filterValues.removeWhere((key, value) => key == f);
                Map<String, String> newFilter = getFilter();
                widget.selectedFilter = newFilter.values.toList().first;
              });
            }
          },
          child: Container(
            margin: const EdgeInsets.all(1.0),
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
                color: Color.fromARGB(93, 171, 167, 167),
                borderRadius: BorderRadius.circular(5.0),
                border:
                    Border.all(color: const Color.fromARGB(93, 73, 72, 72))),
            child: Text("${f}: ${node}",
                style: const TextStyle(
                  fontSize: 11,
                  color: Color.fromARGB(93, 0, 0, 0),
                )),
          ),
        )));
      });
      if (ret.length == 0) return gapH();
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: ret,
      );
    }

    Widget renderTable(data) {
      return Column(children: [
        Expanded(
          child: Datatable(
            data,
            widget.fields,
          ),
        )
      ]);
    }

    Widget renderChart(data) {
      return Column(children: [
        gapH(),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SelectPickerInput(
                title: 'filter-title'.i18n(
                  [widget.filters.join(",")],
                ),
                value: widget.selectedFilter,
                items: getFilter(),
                onSaved: (String value) {
                  setState(() {
                    widget.selectedFilter = value;
                  });
                })),
        gapH(),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: showFilteredList(),
            )),
        if (widget.filterValues.length > 0)
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text("click-cancel".i18n(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontSize: 10,
                      )))),
        Expanded(
          child: Chart(
            data,
            widget.fields,
            widget.selectedFilter,
            getFilterByIndex(),
            onTap: (filter, value) {
              setState(() {
                widget.filters.add(filter);
                widget.filterValues[filter] = value;
                Map<String, String> newFilter = getFilter();
                widget.selectedFilter = newFilter.values.toList().first;
              });
            },
          ),
        ),
      ]);
    }

    Widget showChart(data) {
      double screenWidth = MediaQuery.of(context).size.width;
      return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.viewMode =
                          widget.viewMode == 'chart' ? 'table' : 'chart';
                    });
                  },
                  child: Icon(
                    widget.viewMode == 'chart'
                        ? Icons.table_chart_rounded
                        : Icons.pie_chart,
                    size: 26.0,
                  ),
                ))
          ],
          title: InkWell(
            onTap: () {
              setState(() {
                widget.filters = [];
                widget.filterValues = {};
                widget.selectedFilter = ShoppingModel().firstFilter();
              });
              /*
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => profileDetail()));*/
            },
            child: Text(widget.title),
          ),
        ),
        body:
            widget.viewMode == 'chart' ? renderChart(data) : renderTable(data),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      var theme = Theme.of(context);
      return FutureBuilder(
          future: ShoppingModel().loadData(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return displayError(snapshot, 'main');
              } else if (snapshot.hasData) {
                final data = snapshot.data;
                if (data != false) {
                  if (data["data"].length > 0) {
                    if (widget.selectedFilter!.isEmpty) {
                      String firstFilter = ShoppingModel().firstFilter();
                      widget.selectedFilter = firstFilter;
                    }
                    widget.fields = data["fields"];
                    return showChart(data["data"]);
                  }
                  showAlertDialog(context, 'no-data'.i18n());
                }
                return const BlankPage(title: 'home');
              }
            }
            return showLoadingPage();
          });
    });
  }
}
