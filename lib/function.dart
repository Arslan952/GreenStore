import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_commerce/repository/create_order.dart';
import 'package:woosignal/models/payload/order_wc.dart';
import 'package:woosignal/woosignal.dart';

import 'models/cart_model.dart';

class FunctionClass{
  void createAndSendOrder(BuildContext context,List<CartItem>cartData,Billing billing,Shipping shipping) async {
    WooSignal wooSignal = WooSignal.instance;
    List<LineItems> lineItems = cartData.map((cartItem) {
      return LineItems(
        name: cartItem.product.name,
        productId: cartItem.product.id,
        // variationId: cartItem.product. ?? 0,
        quantity: cartItem.quantity,
        taxClass: "",
        subtotal: (double.parse(cartItem.product.price!) * cartItem.quantity).toStringAsFixed(2),
        total: (double.parse(cartItem.product.price!) * cartItem.quantity).toStringAsFixed(2),
      );
    }).toList();
    // Example order data
    OrderWC orderWC = OrderWC(
      paymentMethod: "bacs",
      paymentMethodTitle: "Direct Bank Transfer",
      setPaid: true,
      status: 'processing',
      currency: 'USD',
      customerNote: "",
      parentId: 0,
      customerId: 0,
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
}