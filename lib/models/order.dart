import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecommerce/models/cart_item.dart';

class OrderModel {
  static const ID = "id";
  static const DESCRIPTION = 'description';
  static const CART = "cart";
  static const USER_ID = "userId";
  static const TOTAL = "total";
  static const STATUS = "status";
  static const CREATED_AT = "createdAt";
  static const PAYMENT_ID = "paymentId";
  static const NAME = "name";

  String _id;
  String _name;
  String _description;
  String _userId;
  String _status;
  String _paymentId;
  String _createdAt;
  int _total;

//  getters
  String get id => _id;

  String get name => _name;

  String get description => _description;

  String get userId => _userId;

  String get status => _status;

  String get paymentId => _paymentId;

  int get total => _total;

  String get createdAt => _createdAt;

  // public variable
  //List cart;
  List<CartItemModel> cart;
  OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()[ID];
    _description = snapshot.data()[DESCRIPTION];
    _total = snapshot.data()[TOTAL];
    _status = snapshot.data()[STATUS];
    _userId = snapshot.data()[USER_ID];
    _createdAt = snapshot.data()[CREATED_AT];
    _paymentId = snapshot.data()[PAYMENT_ID];
    cart = List<CartItemModel>.from(
        snapshot.data()[CART].map((x) => CartItemModel.fromMap(x)));
    _name = snapshot.data()[NAME];
  }
  OrderModel.fromMap(Map data) {
    _id = data[ID];
    _description = data[DESCRIPTION];
    _userId = data[USER_ID];
    _createdAt = data[CREATED_AT];
    _paymentId = data[PAYMENT_ID];

    _total = data[TOTAL];
    _name = data[NAME];
  }

  Map<String, dynamic> toMap() {
    return {
      ID: _id,
      DESCRIPTION: _description,
      USER_ID: _userId,
      PAYMENT_ID: _paymentId,
      TOTAL: _total,
      CREATED_AT: _createdAt,
      NAME: _name
    };
  }
}
