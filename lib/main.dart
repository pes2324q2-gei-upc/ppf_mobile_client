import 'package:flutter/material.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TestingMenu()
    );
  }
}
