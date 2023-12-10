import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import '/element/common.dart';

Widget showLoadingPage() {
  return Center(
      child: Column(children: [
    gapH(h: 10),
    const CircularProgressIndicator(),
  ]));
}

showloading(
  BuildContext context, {
  String? text,
}) {
  var theme = Theme.of(context);

  showDialog(
    //barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          children: [
            const CircularProgressIndicator(),
            gapH(),
            Text(text ?? 'loader-text'.i18n(),
                style: TextStyle(color: theme.colorScheme.primary)),
          ],
        ),
      );
    },
  );
}
