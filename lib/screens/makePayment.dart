import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/helpers/common.dart';
import 'package:flutter_ecommerce/models/cart_item.dart';
import 'package:flutter_ecommerce/provider/user_provider.dart';
import 'package:flutter_ecommerce/screens/existing-card.dart';
import 'package:flutter_ecommerce/screens/home.dart';
import 'package:flutter_ecommerce/services/PaymentServices.dart';
import 'package:flutter_ecommerce/services/order.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Stripe extends StatefulWidget {
  Stripe({Key key}) : super(key: key);

  @override
  StripeState createState() => StripeState();
}

class StripeState extends State<Stripe> {
  OrderServices _orderServices = OrderServices();
  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        payViaNewCard(context);
        break;
      case 1:
        changeScreen(context, ExistingCardsPage());
        break;
    }
  }

  payViaNewCard(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response = await StripeService.payWithNewCard(
      amount: (userProvider.userModel.totalCartPrice).toString(),
      currency: 'USD',
    );
    await dialog.hide();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order of \$${userProvider.userModel.totalCartPrice / 100}',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () async {
                          changeScreen(context, HomePage());
                          var uuid = Uuid();
                          String id = uuid.v4();
                          _orderServices.createOrder(
                              userId: userProvider.user.uid,
                              id: id,
                              paymentId: response.paymentIntentId,
                              status: "complete",
                              totalPrice: userProvider.userModel.totalCartPrice,
                              cart: userProvider.userModel.cart);
                          for (CartItemModel cartItem
                              in userProvider.userModel.cart) {
                            bool value = await userProvider.removeFromCart(
                                cartItem: cartItem);
                            if (value) {
                              userProvider.reloadUserModel();
                              print("Item removed from cart");

                              // _key.currentState.showSnackBar(SnackBar(
                              //     content: Text("Removed from Cart!")));
                            } else {
                              print("ITEM WAS NOT REMOVED");
                            }
                          }
                          // _key.currentState.showSnackBar(
                          //     SnackBar(content: Text("Order created!")));
                          // Navigator.pop(context);
                        },
                        child: Text(
                          "Confirm",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  // order(BuildContext context) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   Padding(
  //     padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
  //     child: Material(
  //         borderRadius: BorderRadius.circular(20.0),
  //         color: Colors.black,
  //         elevation: 0.0,
  //         child: MaterialButton(
  //           onPressed: () async {
  // showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(20.0)),
  //         //this right here
  //         child: Container(
  //           height: 200,
  //           child: Padding(
  //             padding: const EdgeInsets.all(12.0),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   'You will be charged \$${userProvider.userModel.totalCartPrice / 100} upon delivery!',
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 SizedBox(
  //                   width: 320.0,
  //                   child: RaisedButton(
  //                     onPressed: () async {
  //                       var uuid = Uuid();
  //                       String id = uuid.v4();
  //                       _orderServices.createOrder(
  //                           userId: userProvider.user.uid,
  //                           id: id,
  //                           description: "Some random description",
  //                           status: "complete",
  //                           totalPrice: userProvider
  //                               .userModel.totalCartPrice,
  //                           cart: userProvider.userModel.cart);
  //                       for (CartItemModel cartItem
  //                           in userProvider.userModel.cart) {
  //                         bool value = await userProvider
  //                             .removeFromCart(cartItem: cartItem);
  //                         if (value) {
  //                           userProvider.reloadUserModel();
  //                           print("Item added to cart");
  //                           _key.currentState.showSnackBar(SnackBar(
  //                               content:
  //                                   Text("Removed from Cart!")));
  //                         } else {
  //                           print("ITEM WAS NOT REMOVED");
  //                         }
  //                       }
  //                       _key.currentState.showSnackBar(SnackBar(
  //                           content: Text("Order created!")));
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text(
  //                       "Accept",
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                     color: const Color(0xFF1BC0C5),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 320.0,
  //                   child: RaisedButton(
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                       },
  //                       child: Text(
  //                         "Reject",
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                       color: Colors.red),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     });
  //           },
  //           minWidth: MediaQuery.of(context).size.width,
  //           child: Text(
  //             "Add Address",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 20.0),
  //           ),
  //         )),
  //   ),
  // }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
            itemBuilder: (context, index) {
              Icon icon;
              Text text;

              switch (index) {
                case 0:
                  icon = Icon(Icons.add_circle, color: Colors.red);
                  text = Text('Pay via new card');
                  break;
                case 1:
                  icon = Icon(Icons.credit_card, color: Colors.red);
                  text = Text('Pay via existing card');
                  break;
              }

              return InkWell(
                onTap: () {
                  onItemPress(context, index);
                },
                child: ListTile(
                  title: text,
                  leading: icon,
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
                  color: Colors.black26,
                ),
            itemCount: 3),
      ),
    );
  }
}
