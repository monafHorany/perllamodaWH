import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:perllamoda/screens/login.dart';
import 'package:perllamoda/screens/map.dart';
import 'package:perllamoda/screens/order_details.dart';
import 'package:perllamoda/screens/orders.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Perllamoda',
      // initialRoute: '/',
      routes: {
        OrderDetails.routeName: (context) => const OrderDetails(),
        // When navigating to the "/" route, build the FirstScreen widget.
        '/orders': (context) => const Orders(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        // '/details': (context) => const OrderDetails(),
        '/map': (context) => const Map(),
        // '/': (context) => const LogIn(),
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const LogIn(),
    );
  }
}
