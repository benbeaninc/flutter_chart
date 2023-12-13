import 'package:flutter/material.dart';

import '/model/Model.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/element/login/googleLogin/GoogleLogin.dart';

class UserModel extends Model {
  late String? username;
  late String? origin;
  late Map<String, dynamic>? data;
  UserModel({
    this.username,
    this.origin,
    this.data,
  });

  void saveUser(u, o, d) async {
    await setSharedPref('username', u);
    await setSharedPref('loginOrigin', o);
    await setSharedPref('userData', jsonEncode(d));
  }

  void updateUserData(f, d) async {
    data![f] = d;
    await setSharedPref('userData', jsonEncode(data));
  }

  static initSession() async {
    await UserModel().initSharedPref();
    var prefs = await SharedPreferences.getInstance();
    Get.put(prefs);
  }

  void logout() {
    if (origin == 'GoogleLogin') {
      final GoogleLogin _googleSignIn = GoogleLogin();

      //_googleSignIn.disconnect();
    }
  }

  UserModel? getUser() {
    SharedPreferences pref = Get.find();
    String username = pref.getString('username') ?? "";
    if (username == '') {
      return null;
    }

    String loginOrigin = pref.getString('loginOrigin') ?? "";
    if (loginOrigin == '') {
      return null;
    }

    String userData = pref.getString('userData') ?? "{}";
    if (userData != '') {
      return null;
    }

    return UserModel(
      username: username,
      origin: loginOrigin,
      data: jsonDecode(userData),
    );
  }
}
