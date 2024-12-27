import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_commerce/provider/all_app_provider.dart';
import 'package:green_commerce/repository/create_order.dart';
import 'package:green_commerce/user_authentication/auth_service_provider.dart';
import 'package:provider/provider.dart';
import 'package:woosignal/models/payload/order_wc.dart';
import 'package:woosignal/woosignal.dart';

import 'models/auth_model.dart';
import 'models/cart_model.dart';

class FunctionClass{
  void createAndSendOrder(BuildContext context,List<CartItem>cartData,Billing billing,Shipping shipping) async {
    WooSignal wooSignal = WooSignal.instance;
    List<LineItems> lineItems = cartData.map((cartItem) {
      return LineItems(
        name: cartItem.productDetail.name,
        productId: cartItem.productDetail.productId,
        // variationId: cartItem.product. ?? 0,
        quantity: cartItem.quantity,
        taxClass: "",
        subtotal: (double.parse(cartItem.productDetail.price!) * cartItem.quantity).toStringAsFixed(2),
        total: (double.parse(cartItem.productDetail.price!) * cartItem.quantity).toStringAsFixed(2),
      );
    }).toList();
    AuthResponse? authResponse = await Provider.of<AuthServiceProvider>(context,listen: false).retrieveAuthResponse();
    int userId=0;
    if(authResponse!=null){
      userId=authResponse.userId;
      print('id:${authResponse.userId}');
      print('userName:${authResponse.userDisplayName}');
    }
    // Example order data
    OrderWC orderWC = OrderWC(
      paymentMethod: "bacs",
      paymentMethodTitle: "Direct Bank Transfer",
      setPaid: true,
      status: 'processing',
      currency: 'USD',
      customerNote: "",
      parentId: 0,
      customerId:userId,
      billing:billing,
      shipping:shipping,
      lineItems: lineItems,
      shippingLines: [
        ShippingLines(
            methodId: 'flat_rate',
            methodTitle: 'Flat Rate',
            total: '35'
        )
      ],
    );
    try {
      createOrder(orderWC,context);
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
  Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}