import 'package:flutter_ecommerce/helpers/style.dart';
import 'package:flutter_ecommerce/models/order.dart';
import 'package:flutter_ecommerce/screens/order_detail.dart';
import 'package:flutter_ecommerce/provider/user_provider.dart';

import 'package:flutter_ecommerce/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "Orders"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: ListView.builder(
          itemCount: userProvider.orders.length,
          itemBuilder: (_, index) {
            OrderModel _order = userProvider.orders[index];
            return ListTile(
              leading: CustomText(
                text: "\$${_order.total / 100}",
                weight: FontWeight.bold,
                size: 14,
              ),
              title: Text("Tap to check your order details for"),
              onTap: () async {
                await userProvider.getdetailOrders(_order);
                Navigator.push(context,
                        MaterialPageRoute(builder: (_) => Orderdetail()))
                    .then((value) => userProvider.getOrders());
              },
              subtitle: Text(
                  "Order id: ${_order.id} \n Order on: ${_order.createdAt}"),
              trailing: CustomText(
                text: _order.status,
                color: green,
              ),
            );
          }),
    );
  }
}
