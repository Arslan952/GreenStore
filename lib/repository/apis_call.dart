// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:woosignal/woosignal.dart';
// class CallWooSignal  {
//   Future<void> updateProductQuantity(int productId, int newQuantity) async {
//     const String baseUrl = "https://springgreen-magpie-211501.hostingersite.com/wp-json/wc/v3/products";
//     const String consumerKey = "ck_eb52ecd047f5d0169c24abb0d46661f2c64ee5a3";
//     const String consumerSecret = "cs_82a8f5e46665ee61fbae3aa301f0fdf8e0a54067";
//
//     final Uri url = Uri.parse("$baseUrl/$productId?consumer_key=$consumerKey&consumer_secret=$consumerSecret");
//     final response = await http.put(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: json.encode({"stock_quantity": newQuantity}),
//     );
//
//     if (response.statusCode == 200) {
//       print("Product quantity updated successfully!");
//     } else {
//       print("Failed to update product quantity: ${response.body}");
//     }
//   }
//
// }
import 'dart:convert';
import 'package:http/http.dart' as http;

class CallWooSignal {
  static const String baseUrl = "https://springgreen-magpie-211501.hostingersite.com/wp-json/wc/v3";
  static const String consumerKey = "ck_eb52ecd047f5d0169c24abb0d46661f2c64ee5a3";
  static const String consumerSecret = "cs_82a8f5e46665ee61fbae3aa301f0fdf8e0a54067";

  /// Function to create an order
  Future<void> createOrder(Map<String, dynamic> orderData) async {
    final Uri url = Uri.parse("$baseUrl/orders?consumer_key=$consumerKey&consumer_secret=$consumerSecret");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(orderData),
      );
   print(orderData);
      if (response.statusCode == 201) { // 201 = Created
        print("Order created successfully!");
        print("Response: ${response.body}");
      } else {
        print("Failed to create order: ${response.body}");
      }
    } catch (e) {
      print("Error creating order: $e");
    }
  }
}
