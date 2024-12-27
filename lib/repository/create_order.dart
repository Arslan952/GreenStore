import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';
import 'package:woosignal/models/payload/order_wc.dart';
import 'package:woosignal/models/response/order.dart';
import 'package:woosignal/models/response/payment_gateway.dart';
import 'package:woosignal/woosignal.dart';

import '../models/cart_model.dart';
import '../provider/all_app_provider.dart';
Future createOrder(OrderWC orderWc,BuildContext context) async {
  try {
    Provider.of<AllAppProvider>(context,listen: false).updateOrderCreating(true);
    // Create an order
    Order? order = await WooSignal.instance.createOrder(orderWc);

    if (order != null) {
      MotionToast.success(
        title:  Text("Success"),
        description:  Text("Congratulations, woohoo! Your order is created"),
      ).show(context);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Congratulations, woohoo! Your order is created')),
      // );
      Provider.of<AllAppProvider>(context,listen: false).updateOrderCreating(false);
      Provider.of<CartModel>(context,listen: false).clearCart();
      Navigator.pop(context);

    } else {
      Provider.of<AllAppProvider>(context,listen: false).updateOrderCreating(false);
      MotionToast.error(
        title:  Text("Failed"),
        description:  Text("There is Problem with creating order"),
      ).show(context);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('There is Problem with creating order')),
      // );

    }
  } catch (e, stacktrace) {
    Provider.of<AllAppProvider>(context,listen: false).updateOrderCreating(false);
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
