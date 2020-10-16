import 'package:flutter_ecommerce/models/products.dart';
import 'package:flutter_ecommerce/services/products.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  ProductModel _productModel;
  ProductServices _productServices = ProductServices();
  List<ProductModel> products = [];
  List<ProductModel> productsSearched = [];
  ProductModel get productModel => _productModel;
  ProductProvider.initialize() {
    loadProducts();
  }

  loadProducts() async {
    products = await _productServices.getProducts;
    notifyListeners();
  }

  Future search({String productName}) async {
    productsSearched =
        await _productServices.searchProducts(productName: productName);
    notifyListeners();
  }
}
