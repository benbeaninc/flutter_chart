import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Model {
  Future<void> initSharedPref() async {
    SharedPreferences.setMockInitialValues({});
  }

  Future<dynamic> getSharedPref(String code, {String type = 'string'}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic? value;
    switch (type) {
      case 'list':
        value = prefs.getStringList(code);
        break;
      case 'string':
        value = prefs.getString(code) ?? '';
        value = value as String;
        break;
      case 'bool':
        value = prefs.getBool(code) ?? false;
        break;
      case 'double':
        value = prefs.getDouble(code) ?? 0;
        break;
      case 'int':
        value = prefs.getInt(code) ?? 0;
        break;
    }
    return value;
  }

  Future<void> setSharedPref(String code, dynamic value,
      {String type = 'string'}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (type) {
      case 'list':
        prefs.setStringList(code, value);
        break;
      case 'string':
        prefs.setString(code, value);
        break;
      case 'bool':
        prefs.setBool(code, value);
        break;
      case 'double':
        prefs.setDouble(code, value);
        break;
      case 'int':
        prefs.setInt(code, value);
        break;
    }
  }

  static Future clearSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
