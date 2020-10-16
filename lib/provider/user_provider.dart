import 'dart:async';

import 'package:flutter_ecommerce/models/address.dart';
import 'package:flutter_ecommerce/models/cart_item.dart';
import 'package:flutter_ecommerce/models/order.dart';
import 'package:flutter_ecommerce/models/products.dart';
import 'package:flutter_ecommerce/models/user.dart';
import 'package:flutter_ecommerce/models/cards.dart';
import 'package:flutter_ecommerce/services/address.dart';
import 'package:flutter_ecommerce/services/order.dart';
import 'package:flutter_ecommerce/services/users.dart';
import 'package:flutter_ecommerce/services/cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;
  UserServices _userServices = UserServices();
  CardServices _cardServices = CardServices();
  OrderServices _orderServices = OrderServices();
  AddressServices _addressServices = AddressServices();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel _userModel;
  OrderModel _orderModel;
  final formKey = GlobalKey<FormState>();
//  getter
  UserModel get userModel => _userModel;
  OrderModel get orderModel => _orderModel;
  bool hasStripeId = true;

  Status get status => _status;

  User get user => _user;

  // public variables
  List<OrderModel> orders = [];
  List<CardModel> cards = [];
  List<AddressModel> addresses = [];

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onStateChanged);
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  void hasCard() {
    hasStripeId = !hasStripeId;
    notifyListeners();
  }

  Future<void> loadCardsAndPurchase({String userId}) async {
    cards = await _cardServices.getCards(userId: userId);
    orders = await _orderServices.getUserOrders(userId: userId);
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((credential) {
        _firestore
            .collection('users')
            .document(user.uid)
            .setData({'name': name, 'email': email, 'uid': user.uid});
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> address(String name, String number, String address, String city,
      String state, String postalcode, String country) async {
    await _firestore.collection("address").doc().set({
      "name": name,
      "number": number,
      "address": address,
      "city": city,
      "state": state,
      "postalcode": postalcode,
      "country": country,
      'uid': user.uid
    });
    return true;
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController() {
    name.text = "";
    password.text = "";
    email.text = "";
  }

  Future _onStateChanged(User user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      _userModel = await _userServices.getUserById(user.uid);
      cards = await _cardServices.getCards(userId: user.uid);
      orders = await _orderServices.getUserOrders(userId: user.uid);
      _status = Status.Authenticated;
      if (_userModel.stripeId == null) {
        hasStripeId = false;
        notifyListeners();
      }
      print(_userModel.name);
      print(_userModel.email);
      print(_userModel.stripeId);
    }
    notifyListeners();
  }

  Future<bool> addToCart(
      {ProductModel product, String size, String color, int quantity}) async {
    try {
      var uuid = Uuid();
      String cartItemId = uuid.v4();
      List<CartItemModel> cart = _userModel.cart;

      Map cartItem = {
        "id": cartItemId,
        "name": product.name,
        "image": product.picture,
        "productId": product.id,
        "price": product.price,
        "totalSale": product.price * quantity,
        "size": size,
        "color": color,
        "quantity": quantity,
      };

      CartItemModel item = CartItemModel.fromMap(cartItem);
//      if(!itemExists){
      print("CART ITEMS ARE: ${cart.toString()}");
      _userServices.addToCart(userId: _user.uid, cartItem: item);
//      }

      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromCart({CartItemModel cartItem}) async {
    print("THE PRODUC IS: ${cartItem.toString()}");

    try {
      _userServices.removeFromCart(userId: _user.uid, cartItem: cartItem);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  getOrders() async {
    orders = [];
    orders = await _orderServices.getUserOrders(userId: _user.uid);
    notifyListeners();
  }

  getdetailOrders(OrderModel order) async {
    orders = await _orderServices.getDetailsOrders(id: order.id);
    notifyListeners();
  }

  getAddress() async {
    addresses = await _addressServices.getUserAddress();
    notifyListeners();
  }

  Future<void> reloadUserModel() async {
    _userModel = await _userServices.getUserById(user.uid);
    notifyListeners();
  }
}
