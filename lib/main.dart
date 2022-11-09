import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:perllamoda/screens/login.dart';
import 'package:perllamoda/screens/map.dart';
import 'package:perllamoda/screens/order_details.dart';
import 'package:perllamoda/screens/orders.dart';

Future<void> main() async {
  await dotenv.load();
  SharedPreferences.getInstance().then((prefs) {
    runApp(LandingPage(prefs: prefs));
  });
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // runApp(const MyApp());
}

class LandingPage extends StatelessWidget {
  final SharedPreferences prefs;
  const LandingPage({super.key, required this.prefs});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _decideMainPage(),
    );
  }

  _decideMainPage() {
    if (prefs.getString('token') != null) {
      return Orders(prefs: prefs);
      // return RegistrationPage(prefs: prefs);
    } else {
      return LogIn(prefs: prefs);
    }
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations(
//         [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Perllamoda',
//       routes: {
//         OrderDetails.routeName: (context) => const OrderDetails(),
//         '/orders': (context) => const Orders(prefs: null,),
//         '/map': (context) => const Map(),
//       },
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const LogIn(prefs: null,),
//     );
//   }
// }
