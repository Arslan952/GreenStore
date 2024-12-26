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
import 'dart:developer';
import 'package:green_commerce/models/customerModel.dart';
import 'package:http/http.dart' as http;
import 'package:woosignal/models/response/payment_gateway.dart';
import 'package:woosignal/models/response/product_variation.dart';

class CallWooSignal {
  static const String baseUrl = "https://springgreen-magpie-211501.hostingersite.com/wp-json/wc/v3";
  static const String consumerKey = "ck_eb52ecd047f5d0169c24abb0d46661f2c64ee5a3";
  static const String consumerSecret = "cs_82a8f5e46665ee61fbae3aa301f0fdf8e0a54067";

  /// Function to create an order
  Future<void> createOrder(Map<String, dynamic> orderData) async {
    final Uri url = Uri.parse(
        "$baseUrl/orders?consumer_key=$consumerKey&consumer_secret=$consumerSecret");

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

  /// Function to get payment gateways
  /// Function to get payment gateways
  Future<List<PaymentGateWay>> getPaymentGateways() async {
    final Uri url = Uri.parse(
        "$baseUrl/payment_gateways?consumer_key=$consumerKey&consumer_secret=$consumerSecret");

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      print(url);
      if (response.statusCode == 200) { // 200 = OK
        print("Payment gateways fetched successfully!");

        // Parse the JSON response into a list of PaymentGateWay objects
        final List<dynamic> jsonList = jsonDecode(response.body);
        print(jsonList);
        final List<PaymentGateWay> paymentGateways = jsonList
            .map((json) =>
            PaymentGateWay.fromJson(json as Map<String, dynamic>))
            .toList();

        // Debugging: Print each payment gateway
        for (var gateway in paymentGateways) {
          print("Gateway: ${gateway.title}, Enabled: ${gateway.enabled}");
        }

        return paymentGateways;
      } else {
        print("Failed to fetch payment gateways: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching payment gateways: $e");
      return [];
    }
  }

  Future<List<ProductVariation>> getProductVariations(int productId) async {
    final Uri url = Uri.parse(
        "$baseUrl/products/$productId/variations?consumer_key=$consumerKey&consumer_secret=$consumerSecret");

    try {
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      print(url);

      if (response.statusCode == 200) { // 200 = OK
        print("Product variations fetched successfully!");

        // Parse the JSON response into a list of ProductVariation objects
        final List<dynamic> jsonList = jsonDecode(response.body);
        print(jsonList);

        final List<ProductVariation> productVariations = jsonList
            .map((json) =>
            ProductVariation.fromJson(json as Map<String, dynamic>))
            .toList();

        // Debugging: Print each product variation
        for (var variation in productVariations) {
          print(
              "Variation: ${variation.attributes[0].option}, Price: ${variation
                  .price}");
        }

        return productVariations;
      } else {
        print("Failed to fetch product variations: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching product variations: $e");
      return [];
    }
  }

  // add review of products
  Future<bool> addReview({
    required int productId,
    required String reviewer,
    required String reviewerEmail,
    required String review,
    required int rating,
    String status = "approved",
  }) async {
    final Uri url = Uri.parse("$baseUrl/products/reviews");

    final Map<String, dynamic> body = {
      "product_id": productId,
      "reviewer": reviewer,
      "reviewer_email": reviewerEmail,
      "review": review,
      "rating": rating,
      "status": status,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Basic ${base64Encode(
              utf8.encode("$consumerKey:$consumerSecret"))}",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        print("Review added successfully!");
        return true;
      } else {
        print("Failed to add review: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error while adding review: $e");
      return false;
    }
  }

  Future<bool> registerUser(CustomerModel model) async {
    // Base64 encode WooCommerce credentials
    var authToken = base64.encode(utf8.encode("$consumerKey:$consumerSecret"));

    // Request headers
    Map<String, String> requestHeader = {
      "Content-Type": "application/json",
      "Authorization": "Basic $authToken",
    };

    // URL for WooCommerce customer creation
    final Uri url = Uri.parse("$baseUrl/customers");

    // Prepare request body from CustomerModel
    try {
      final response = await http.post(
        url,
        headers: requestHeader,
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 201) {
        print("Customer successfully registered!");
        return true;  // Registration successful
      } else {
        final errorData = jsonDecode(response.body);
        print("Error: ${errorData['message'] ?? 'Unknown error'}");
        return false;  // Registration failed
      }
    } catch (e) {
      print("Error during registration: $e");
      return false;  // Error occurred during request
    }
  }

}
