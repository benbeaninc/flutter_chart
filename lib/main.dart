import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'HomePage.dart';
import 'LoginPage.dart';
import 'model/UserModel.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Widget showPage() {
    UserModel? user = UserModel().getUser();
    if (user == null) {
      //return LoginPage();
    }
    return HomePage(title: 'Shopping Trend');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];

    return MaterialApp(
      title: 'Shopping Trend',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      supportedLocales: const [
        Locale('en', 'US'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        return const Locale('en', 'US');
      },
      localizationsDelegates: [
        // delegate from flutter_localization
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        // delegate from localization package.
        LocalJsonLocalization.delegate,
      ],
      //home: HomePage(title: 'Shopping Trend'),
      home: showPage(),
    );
  }
}
