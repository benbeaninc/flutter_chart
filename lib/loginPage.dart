import 'package:flutter/material.dart';
import '/element/login/googleLogin/GoogleLogin.dart';
//import '/element/login/fbLogin/fbLogin.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    super.key,
  });
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    //moving forward this part to include other login platform
    return Scaffold(
        appBar: AppBar(),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: const GoogleLogin(),
        ));
  }
}
