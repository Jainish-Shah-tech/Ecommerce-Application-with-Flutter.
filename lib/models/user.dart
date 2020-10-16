import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecommerce/services/users.dart';

import 'cart_item.dart';

class UserModel {
  static const ID = "uid";
  static const NAME = "name";
  static const EMAIL = "email";
  static const STRIPE_ID = "stripeId";
  static const CART = "cart";
  static const ACTIVE_CARD = 'activeCard';
  static const ORDER_ID = "orderId";

  String _name;
  String _email;
  String _id;
  String _stripeId;
  String _activeCard;
  String _orderId;
  int _priceSum = 0;

//  getters
  String get name => _name;

  String get email => _email;

  String get id => _id;

  String get activeCard => _activeCard;

  String get stripeId => _stripeId;

  String get orderId => _orderId;

  // public variables
  List<CartItemModel> cart;
  int totalCartPrice;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = snapshot.data()[NAME];
    _email = snapshot.data()[EMAIL];
    _id = snapshot.data()[ID];
    _stripeId = snapshot.data()[STRIPE_ID] ?? "";
    _orderId = snapshot.data()[ORDER_ID] ?? "";
    cart = _convertCartItems(snapshot.data()[CART] ?? []);
    totalCartPrice = snapshot.data()[CART] == null
        ? 0
        : getTotalPrice(cart: snapshot.data()[CART]);
    _activeCard = snapshot.data()[ACTIVE_CARD] ?? null;
  }

  List<CartItemModel> _convertCartItems(List cart) {
    List<CartItemModel> convertedCart = [];
    for (Map cartItem in cart) {
      convertedCart.add(CartItemModel.fromMap(cartItem));
    }
    return convertedCart;
  }

  int getTotalPrice({List cart}) {
    if (cart == null) {
      return 0;
    }
    for (Map cartItem in cart) {
      _priceSum += cartItem["price"] * cartItem["quantity"];
    }

    int total = _priceSum;
    return total;
  }
}
