import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text("orders")),
      body: SafeArea(
        child: FutureBuilder(
          future: http.get(Uri.parse(
              "${dotenv.env["API_URL"]!}/order/fetchAllNewOrder")), // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                    elevation: 14,
                    key: ValueKey(index.toString()),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ListTile(
                                isThreeLine: true,
                                leading: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(30),
                                    child: DecoratedBox(
                                      decoration: const BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 84, 73, 133)),
                                      child: Center(
                                        child: Text(
                                          resData[index]?["user"]?["name"] ??
                                              "N/A",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(resData[index]["id"]?.toString() ??
                                    "Empty"),
                                subtitle: Text(resData[index]["ordered_by"]),
                                trailing: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const Text("Total Price"),
                                    Text(
                                        "${resData[index]["shipping_fees"] + (resData[index]["price"])}  "
                                        "${resData[index]["order_currency"]}"),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                          context, OrderDetails.routeName,
                                          arguments: ScreenArguments(
                                              orderId: resData[index]["id"],
                                              location: resData[index]
                                                  ["locations"]))
                                      .then((_) => setState(() {}));
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: ListBody(
                                children: [
                                  resData[index]["shipped"]
                                      ? const Icon(
                                          Icons.local_shipping,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.local_shipping,
                                        ),
                                ],
                              ),
                            )
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
