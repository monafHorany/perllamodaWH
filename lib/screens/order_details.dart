import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key});
  static const routeName = "/details";
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final list = [];
    for (var i = 0; i < args.location.length; i++) {
      list.add(args.location[i]["location"]);
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            child: const Icon(Icons.share),
            onTap: () async {
              await Share.share('check out my website https://example.com');
            },
          )
        ],
        title: Text(list.join("         ").replaceAll("/", "->")),
      ),
      body: FutureBuilder(
        future: http.get(Uri.parse(
            "${dotenv.env["API_URL"]!}/order/order/${args.orderId}")), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map resData = jsonDecode(snapshot.data!.body);
            // final resData = jsonDecode(snapshot.data!.body);
            List<dynamic> items = List.of(resData["order_items"]);
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: const [
                    Text("test"),
                    Text("test"),
                  ],
                ),
                ListView.builder(
                  itemCount: items.length,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, index) {
                    return Card(
                      key: ValueKey(index.toString()),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: ListTile(
                            // contentPadding: const EdgeInsets.all(20),
                            leading: ClipOval(
                              child: SizedBox.fromSize(
                                size: const Size.fromRadius(30), // Image radius
                                child: Image.network(
                                    items[index]?["item_image_link"],
                                    fit: BoxFit.fill),
                              ),
                            ),
                            title: Text(items[index]["item_name"]),
                            // subtitle: Text(resData[index]["ordered_by"]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
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
    );
  }
}

class ScreenArguments {
  final int orderId;
  final List<dynamic> location;

  ScreenArguments({required this.orderId, required this.location});
}
