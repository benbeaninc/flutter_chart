import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

showAlertDialog(BuildContext context, String description,
    {String title = "Error"}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'dialog-ok'.i18n()),
            child: Text('dialog-ok'.i18n()),
          ),
        ],
      );
    },
  );
}

showSuccessDialog(BuildContext context, String description, {String? title}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? 'dialog-success'.i18n()),
        content: Text(description),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'dialog-ok'.i18n()),
            child: Text('dialog-ok'.i18n()),
          ),
        ],
      );
    },
  );
}

showConfirmDialog(BuildContext context,
    {String description = '',
    String? title,
    Function? onCancel,
    Function? onOK}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? 'dialog-areyousure'.i18n()),
        content: Text(description),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              if (onOK != null) {
                onOK();
              }
            },
            child: Text('dialog-ok'.i18n()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              if (onCancel != null) {
                onCancel();
              }
            },
            child: Text('dialog-cancel'.i18n()),
          ),
        ],
      );
    },
  );
}
