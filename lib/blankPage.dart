import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'element/common.dart';
import 'element/loader.dart';
import 'model/DataModel.dart';

class BlankPage extends StatefulWidget {
  const BlankPage({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<BlankPage> createState() => _BlankPage();
}

class _BlankPage extends State<BlankPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var theme = Theme.of(context);

      return Column(
        children: [Text('This is a blank page for ' + widget.title)],
      );
    });
  }
}
