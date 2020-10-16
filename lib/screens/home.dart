import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_ecommerce/helpers/common.dart';
import 'package:flutter_ecommerce/helpers/style.dart';
import 'package:flutter_ecommerce/provider/product.dart';
import 'package:flutter_ecommerce/provider/user_provider.dart';
import 'package:flutter_ecommerce/screens/product_search.dart';
import 'package:flutter_ecommerce/services/products.dart';
import 'package:flutter_ecommerce/widgets/custom_text.dart';
import 'package:flutter_ecommerce/widgets/featured_products.dart';
import 'package:flutter_ecommerce/widgets/orders.dart';
import 'package:flutter_ecommerce/widgets/product_card.dart';
import 'package:flutter_ecommerce/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import 'cart.dart';
import 'credit_card.dart';
import 'manage_card.dart';
import 'order.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<ScaffoldState>();
  ProductServices _productServices = ProductServices();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      key: _key,
      backgroundColor: white,
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: black),
              accountName: CustomText(
                text: userProvider.userModel?.name ?? "username lading...",
                color: white,
                weight: FontWeight.bold,
                size: 18,
              ),
              accountEmail: CustomText(
                text: userProvider.userModel?.email ?? "email loading...",
                color: white,
              ),
            ),
            // ListTile(
            //   leading: Icon(Icons.add),
            //   title: CustomText(
            //     text: "Add Credit Card",
            //   ),
            //   onTap: () {
            //     changeScreen(
            //         context,
            //         CreditCard(
            //           title: "Add card",
            //         ));
            //   },
            // ),
            // ListTile(
            //   leading: Icon(Icons.credit_card),
            //   title: CustomText(
            //     text: "Manage Cards",
            //   ),
            //   onTap: () {
            //     changeScreen(context, ManagaCardsScreen());
            //   },
            // ),
            ListTile(
              onTap: () async {
                await userProvider.getOrders();
                changeScreen(context, OrdersScreen());
              },
              leading: Icon(Icons.bookmark_border),
              title: CustomText(text: "My orders"),
            ),
            // ListTile(
            //   leading: Icon(Icons.credit_card),
            //   title: CustomText(
            //     text: "Buy Again",
            //   ),
            //   onTap: () {
            //     changeScreen(context, featuredOrders());
            //   },
            // ),
            ListTile(
              onTap: () {
                userProvider.signOut();
              },
              leading: Icon(Icons.exit_to_app),
              title: CustomText(text: "Log out"),
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Future.value(false);
        },
        child: SafeArea(
          child: ListView(
            children: <Widget>[
//           Custom App bar
              Stack(
                children: <Widget>[
                  Positioned(
                    top: 10,
                    right: 20,
                    child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              _key.currentState.openEndDrawer();
                            },
                            child: Icon(Icons.menu))),
                  ),
                  Positioned(
                    top: 10,
                    right: 60,
                    child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              changeScreen(context, CartScreen());
                            },
                            child: Icon(Icons.shopping_cart))),
                  ),
                  Positioned(
                    top: 10,
                    right: 100,
                    child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              _key.currentState.showSnackBar(
                                  SnackBar(content: Text("User profile")));
                            },
                            child: Icon(Icons.person))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'What are\nyou Shopping for?',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),

//          Search Text field
//            Search(),

              Container(
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8, left: 8, right: 8, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.search,
                        color: black,
                      ),
                      title: TextField(
                        textInputAction: TextInputAction.search,
                        onSubmitted: (pattern) async {
                          await productProvider.search(productName: pattern);
                          changeScreen(context, ProductSearchScreen());
                        },
                        decoration: InputDecoration(
                          hintText: "blazer, dress...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 200.0,
                child: new Carousel(
                  boxFit: BoxFit.cover,
                  images: [
                    AssetImage('images/w3.jpeg'),
                    AssetImage('images/m1.jpeg'),
                    AssetImage('images/c1.jpg'),
                    AssetImage('images/w4.jpeg'),
                    AssetImage('images/m2.jpg'),
                  ],
                  autoplay: true,
//      animationCurve: Curves.fastOutSlowIn,
//      animationDuration: Duration(milliseconds: 1000),
                  dotSize: 4.0,
                  indicatorBgPadding: 2.0,
                ),
              ),

//            featured products
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: new Text('Featured products')),
                  ),
                ],
              ),
              FeaturedProducts(),

//          recent products
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: new Text('Recent products')),
                  ),
                ],
              ),

              Column(
                children: productProvider.products
                    .map((item) => GestureDetector(
                          child: ProductCard(
                            product: item,
                          ),
                        ))
                    .toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
//Row(
//mainAxisAlignment: MainAxisAlignment.end,
//children: <Widget>[
//GestureDetector(
//onTap: (){
//key.currentState.openDrawer();
//},
//child: Icon(Icons.menu))
//],
//),
