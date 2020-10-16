// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:stripe_payment/stripe_payment.dart';
// import 'package:flutter/cupertino.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:modal_progress_hud/modal_progress_hud.dart';

// String text = 'Click the button to start the payment';
// double totalCost = 10.0;
// double tip = 1.0;
// double tax = 0.0;
// double taxPercent = 0.2;
// int amount = 0;
// bool showSpinner = false;
// String url = 'https://us-central1-demostripe-b9557.cloudfunctions.net/StripePI';

// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   @override
//   void initState() {
//     super.initState();
//     StripePayment.setOptions(
//       StripeOptions(
//           publishableKey:
//               'pk_test_51HPh82D4tmJsrtnW4GEKRYe6bCT0Rn4yfKhCfzbrBXye4aDQZmXvFb4DoisYuWV8WX1jQIjfcNorYukIQzden44100kw96DfPR',
//           merchantId: 'merchant.id',
//           androidPayMode: 'test'),
//     );
//   }

//   void checkIfNativePayReady() async {
//     print('started to check if native pay ready');
//     bool deviceSupportNativePay = await StripePayment.deviceSupportsNativePay();
//     bool isNativeReady = await StripePayment.canMakeNativePayPayments(
//         ['american_express', 'visa', 'maestro', 'master_card']);
//     deviceSupportNativePay && isNativeReady
//         ? createPaymentMethodNative()
//         : createPaymentMethod();
//   }

//   Future<void> createPaymentMethodNative() async {
//     print('started NATIVE payment...');
//     StripePayment.setStripeAccount(null);
//     List<ApplePayItem> items = [];
//     items.add(ApplePayItem(
//       label: 'Demo Order',
//       amount: totalCost.toString(),
//     ));
//     if (tip != 0.0)
//       items.add(ApplePayItem(
//         label: 'Tip',
//         amount: tip.toString(),
//       ));
//     if (taxPercent != 0.0) {
//       tax = ((totalCost * taxPercent) * 100).ceil() / 100;
//       items.add(ApplePayItem(
//         label: 'Tax',
//         amount: tax.toString(),
//       ));
//     }
//     items.add(ApplePayItem(
//       label: 'Vendor A',
//       amount: (totalCost + tip + tax).toString(),
//     ));
//     amount = ((totalCost + tip + tax) * 100).toInt();
//     print('amount in pence/cent which will be charged = $amount');
//     //step 1: add card
//     PaymentMethod paymentMethod = PaymentMethod();
//     Token token = await StripePayment.paymentRequestWithNativePay(
//       androidPayOptions: AndroidPayPaymentRequest(
//         total_price: (totalCost + tax + tip).toStringAsFixed(2),
//         currency_code: 'GBP',
//       ),
//       applePayOptions: ApplePayPaymentOptions(
//         countryCode: 'GB',
//         currencyCode: 'GBP',
//         items: items,
//       ),
//     );
//     paymentMethod = await StripePayment.createPaymentMethod(
//       PaymentMethodRequest(
//         card: CreditCard(
//           token: token.tokenId,
//         ),
//       ),
//     );
//     paymentMethod != null
//         ? processPaymentAsDirectCharge(paymentMethod)
//         : showDialog(
//             context: context,
//             builder: (BuildContext context) => ShowDialogToDismiss(
//                 title: 'Error',
//                 content:
//                     'It is not possible to pay with this card. Please try again with a different card',
//                 buttonText: 'CLOSE'));
//   }

//   Future<void> createPaymentMethod() async {
//     StripePayment.setStripeAccount(null);
//     tax = ((totalCost * taxPercent) * 100).ceil() / 100;
//     amount = ((totalCost + tip + tax) * 100).toInt();
//     print('amount in pence/cent which will be charged = $amount');
//     //step 1: add card
//     PaymentMethod paymentMethod = PaymentMethod();
//     paymentMethod = await StripePayment.paymentRequestWithCardForm(
//       CardFormPaymentRequest(),
//     ).then((PaymentMethod paymentMethod) {
//       return paymentMethod;
//     }).catchError((e) {
//       print('Errore Card: ${e.toString()}');
//     });
//     paymentMethod != null
//         ? processPaymentAsDirectCharge(paymentMethod)
//         : showDialog(
//             context: context,
//             builder: (BuildContext context) => ShowDialogToDismiss(
//                 title: 'Error',
//                 content:
//                     'It is not possible to pay with this card. Please try again with a different card',
//                 buttonText: 'CLOSE'));
//   }

//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
