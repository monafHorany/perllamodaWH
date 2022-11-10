import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:perllamoda/screens/order_details.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
    return Scaffold(
      appBar: AppBar(title: const Text("orders")),
      body: SafeArea(
        child: FutureBuilder<Response>(
          future: http.get(Uri.parse(
              "${dotenv.env["API_URL"]!}/order/fetchAllNewOrder")), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
            if (snapshot.hasData) {
              List<dynamic> resData =
                  List<dynamic>.from(json.decode(snapshot.data!.body));
              // final resData = jsonDecode(snapshot.data!.body);
              return ListView.builder(
                itemCount: resData.length,
                physics: const ScrollPhysics(),
                // padding: const EdgeInsets.all(8),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    key: ValueKey(index.toString()),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  child: Align(
                                    alignment: Alignment.center,
                                    widthFactor: 1,
                                    child: Text(
                                        resData[index]?["user"]?["name"] ??
                                            "N/A",
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                                title: Text(resData[index]["id"]?.toString() ??
                                    "Empty"),
                                subtitle: Text(resData[index]["ordered_by"]),
                                trailing: const Icon(Icons.local_shipping),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, OrderDetails.routeName,
                                      arguments: ScreenArguments(
                                          resData[index]["id"]));
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Column(children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
              ]));
            } else {
              return Center(
                child: Column(
                  children: const [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 36),
                      child: Text('Awaiting result...',
                          style: TextStyle(fontSize: 30)),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
