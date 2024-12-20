import 'package:flutter/material.dart';
import 'package:green_commerce/models/product_model.dart';
import 'package:woosignal/models/response/product.dart';

class CartItem {
  final ProductDetail productDetail;
  int quantity;

  CartItem({required this.productDetail, this.quantity = 1});
}

class CartModel extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;
  int productQty = 0;

  double get totalPrice {
    double total = 0.0;
    for (var item in _cartItems) {
      try {
        total += double.parse(item.productDetail.price ?? '0') * item.quantity;
      } catch (e) {
        // Handle parsing error by skipping the item or logging the error
        print("Error parsing price: ${item.productDetail.price}");
      }
    }
    return total;
  }

  int get totalQuantity {
    int totalQty = 0;
    for (var item in _cartItems) {
      totalQty += item.quantity;
    }
    return totalQty;
  }

  void addToCart(ProductDetail product, {int quantity = 1}) {
    // Check if the product is already in the cart
    print(product.productId);
    final existingItem = _cartItems.firstWhere(
          (item) => item.productDetail.productId == product.productId,
      orElse: () => CartItem(productDetail: product),
    );

    if (_cartItems.contains(existingItem)) {
      // If the product is already in the cart, update its quantity
      existingItem.quantity = quantity;
    } else {
      // If not, add the product to the cart with the specified quantity
      _cartItems.add(CartItem(productDetail: product, quantity: quantity));
      existingItem.quantity = quantity;
    }

    notifyListeners();
  }


  void removeFromCart(ProductDetail product) {
    _cartItems.removeWhere((item) => item.productDetail.productId == product.productId);

  }

  void updateQuantity(CartItem cartItem, int newQuantity) {
    cartItem.quantity = newQuantity;
    notifyListeners();
  }

  // Function to clear the cart
  void clearCart() {
    _cartItems.clear(); // Remove all items from the cart
    notifyListeners(); // Notify listeners that the cart has been cleared
  }
}
