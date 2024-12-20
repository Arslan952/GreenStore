import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_commerce/repository/apis_call.dart';
import 'package:green_commerce/repository/create_order.dart';
import 'package:provider/provider.dart';
import 'package:woosignal/models/payload/order_wc.dart';
import 'package:woosignal/models/response/product.dart';
import 'package:woosignal/woosignal.dart';
import '../models/cart_model.dart';
import 'billingInformation.dart';
class CartScreen extends StatelessWidget {

  @override
  void createAndSendOrder(BuildContext context,String name,List<CartItem>cartData) async {
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
      billing:Billing(
        firstName: "John",
        lastName: "Doe",
        address1: "969 Market",
        address2: "",
        city: "San Francisco",
        state: "CA",
        postcode: "94103",
        country: "US",
        email: "john.doe@example.com",
        phone: "(555) 555-5555",
      ),
      shipping:Shipping(
        firstName: "John",
        lastName: "Doe",
        address1: "969 Market",
        address2: "",
        city: "San Francisco",
        state: "CA",
        postcode: "94103",
        country: "US",
      ),
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
      // Send the order to WooSignal
      createOrder(orderWC,context);
      // await CallWooSignal().createOrder(orderWC.toJson());
      // Order? order = await wooSignal.createOrder(orderWC);
       SnackBar(content: Text('Order Created successfully'));
      print("okokok");
      // print('here is order id${order?.status.toString()}');
      // .createOrderWC(orderWC: order);

      // if (responseOrder != null && responseOrder.id != null) {
      //   print("Order created successfully! Order ID: ${responseOrder.id}");
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Order created successfully! ID: ${responseOrder.id}")),
      //   );
      // } else {
      //   print("Failed to create order");
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Failed to create order")),
      //   );
      // }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart" ,style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<CartModel>(
        builder: (context, cartModel, child) {
          // If cart is empty
          if (cartModel.cartItems.isEmpty) {
            return const Center(
              child: Text("Your cart is empty!", style: TextStyle(fontSize: 18)),
            );
          }
          print("okoko");
          print( cartModel.cartItems.length);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  child: ListView.builder(
                    itemCount: cartModel.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartModel.cartItems[index];
                      return
                        CartItemCard(cartItem: cartItem);
                    },
                  ),
                ),

                // Total Price
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: \$${cartModel.totalPrice.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => BillingDetailsScreen(cartData:cartModel.cartItems,)));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Checkout",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  CartItemCard({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Product Image
            Image.network(
              cartItem.productDetail.image![0].src!,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 16),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.productDetail.name??"",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "\$${cartItem.productDetail.price}",
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity Adjustment
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (cartItem.quantity > 1) {
                                context.read<CartModel>().updateQuantity(cartItem, cartItem.quantity - 1);
                              }
                            },
                          ),
                          Text(cartItem.quantity.toString()),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              context.read<CartModel>().updateQuantity(cartItem, cartItem.quantity + 1);
                            },
                          ),
                        ],
                      ),
                      // Remove Button
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<CartModel>().removeFromCart(cartItem.productDetail);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
