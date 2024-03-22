import 'package:flutter/material.dart';
import 'package:ppf_mobile_client/views/login_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ppf_mobile_client/classes/language_constants.dart';
import 'package:ppf_mobile_client/views/testing_menu.dart';


void main() {
  /*
  const bool isDebug = bool.fromEnvironment('DEBUG', defaultValue: true);
  const String userApi = String.fromEnvironment('USER_API', defaultValue: 'http://127.0.0.1:8081');
  const String routeApi = String.fromEnvironment('ROUTE_API', defaultValue: 'http://127.0.0.1:8080');

  print('Is Debug Mode: $isDebug');
  print('User API: $userApi');
  print('Route API: $routeApi');
  */

  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localization',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('en',''),
      home: const TestingMenu());

  }
}