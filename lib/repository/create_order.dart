import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woosignal/models/payload/order_wc.dart';
import 'package:woosignal/models/response/order.dart';
import 'package:woosignal/models/response/payment_gateway.dart';
import 'package:woosignal/woosignal.dart';

import '../models/cart_model.dart';
Future createOrder(OrderWC orderWc,BuildContext context) async {
  try {
    // Create an order
    Order? order = await WooSignal.instance.createOrder(orderWc);

    if (order != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Congratulations, woohoo! Your order is created')),
      );
      Provider.of<CartModel>(context,listen: false).clearCart();

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('There is Problem with creating order')),
      );

    }
  } catch (e, stacktrace) {
    print('Error creating order: $e');
    print('Stack trace: $stacktrace');
  }
}
Future getPaymentGateWays  ()async {
  List<PaymentGateWay> paymentGateways = await WooSignal.instance.getPaymentGateways();

    // Print JSON string
    // final jsonString = jsonEncode(paymentGateways);
    print('Here are all orders in JSON format: ${paymentGateways.first.description}');
  }
