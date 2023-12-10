import 'package:flutter/material.dart';
import '/model/DataRowModel.dart';
import 'package:intl/intl.dart';

class VerticalChart extends StatefulWidget {
  const VerticalChart({
    super.key,
    required this.data,
    required this.map,
    this.onTap,
    this.loading = false,
  });
  final List<DataRowModel> data;
  final Map<String, String> map;
  final bool loading;
  final Function? onTap;

  @override
  _VerticalChart createState() => _VerticalChart();
}

class _VerticalChart extends State<VerticalChart> {
  List<Widget> getList() {
    List<Widget> arr = [];
    int largestCount = 0;
    widget.data.forEach((element) {
      if (element.count > largestCount) {
        largestCount = element.count;
      }
    });
    widget.data.sort((item1, item2) {
      return item2.count.compareTo(item1.count);
    });
    widget.data.forEach((element) {
      if (element.count == 0) return;
      String title = widget.map[element.category] ?? element.category;
      arr.add(
        InkWell(
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!(element.category);
            }
          },
          child: ChartLine(
            title: title,
            rate: element.count / largestCount,
            number: element.count,
          ),
        ),
      );
    });
    return arr.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: getList(),
      )),
    );
  }
}

class ChartLine extends StatelessWidget {
  const ChartLine({
    super.key,
    required this.rate,
    required this.title,
    required this.number,
    this.height = 20,
    this.fontSize = 12,
  });

  final double rate;
  final String title;
  final int number;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final lineWidget = constraints.maxWidth * rate;
      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(minWidth: lineWidget),
              child: IntrinsicWidth(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: fontSize,
                      ),
                    ),
                    Text(
                      NumberFormat.decimalPattern('en').format(number),
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.blue,
              height: height,
              width: lineWidget,
            ),
          ],
        ),
      );
    });
  }
}
