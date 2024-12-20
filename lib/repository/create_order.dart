import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:woosignal/models/payload/order_wc.dart';
import 'package:woosignal/models/response/order.dart';
import 'package:woosignal/models/response/payment_gateway.dart';
import 'package:woosignal/woosignal.dart';
Future createOrder(OrderWC orderWc,BuildContext context) async {
  try {
    // Create an order
    Order? order = await WooSignal.instance.createOrder(orderWc);

    if (order != null) {
      print('Order ID: ${order.id}');
      print("Congratulations, woohoo! Your order is created.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Congratulations, woohoo! Your order is created')),
      );

      // Fetch all orders

    } else {
      print('Order creation failed. Possible response details:');
      print('Response: ${order?.toJson()}');
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
