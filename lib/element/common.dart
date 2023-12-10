// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

Widget gapH({double h = 5}) {
  return SizedBox(
    height: h,
  );
}

Widget gapW({double w = 5}) {
  return SizedBox(
    width: w,
  );
}

Widget displayError(snapshot, text) {
  return Center(
      child: Text(
    'msg-error'.i18n([snapshot.error, text]),
    style: const TextStyle(fontSize: 18),
  ));
}
