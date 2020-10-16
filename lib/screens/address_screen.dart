import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ecommerce/helpers/style.dart';
import 'package:flutter_ecommerce/models/address.dart';
import 'package:flutter_ecommerce/models/order.dart';
import 'package:flutter_ecommerce/screens/order_detail.dart';
import 'package:flutter_ecommerce/provider/user_provider.dart';

import 'package:flutter_ecommerce/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "Existing address"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: ListView.builder(
          itemCount: userProvider.addresses.length,
          itemBuilder: (_, index) {
            AddressModel _address = userProvider.addresses[index];
            return ListTile(
              leading: CustomText(
                text: "\$${_address.name}",
                weight: FontWeight.bold,
                size: 14,
              ),
              title: Text(_address.address),
              // onTap: () async {
              //   await userProvider.getdetailOrders(_order);
              //   Navigator.push(context,
              //           MaterialPageRoute(builder: (_) => Orderdetail()))
              //       .then((value) => userProvider.getOrders());
              // },
              subtitle:
                  Text("City: ${_address.city} \n State: ${_address.state} "),
              trailing: CustomText(
                text: _address.country,
                color: green,
              ),
            );
          }),
    );
  }
}
