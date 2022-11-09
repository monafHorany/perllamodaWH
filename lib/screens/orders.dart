import 'package:flutter/material.dart';
import 'package:perllamoda/screens/order_details.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Orders extends StatefulWidget {
  const Orders({super.key, required SharedPreferences prefs});
  @override
  State<Orders> createState() => _OrdersState();
}

void initialization() async {
  await Future.delayed(const Duration(milliseconds: 50));
  FlutterNativeSplash.remove();
}

class _OrdersState extends State<Orders> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    int orderId = 300;
    return Scaffold(
      appBar: AppBar(title: const Text("orders")),
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            OrderDetails.routeName,
            arguments: ScreenArguments(orderId),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
