import 'package:flutter/material.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({super.key});
  static const routeName = "/details";
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.orderId.toString()),
      ),
      body: const Center(
        child: Text("second screen"),
      ),
    );
  }
}

class ScreenArguments {
  final int orderId;

  ScreenArguments(this.orderId);
}
