import 'package:flutter_ecommerce/models/order.dart';
import 'package:flutter_ecommerce/services/order.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  OrderModel _orderModel;

  OrderServices _orderServices = OrderServices();
  List<OrderModel> orders = [];
  OrderModel get orderModel => _orderModel;

  Future order({String userId}) async {
    orders = await _orderServices.getUserOrders(userId: userId);
    notifyListeners();
  }
}
