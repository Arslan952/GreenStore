import 'package:flutter/material.dart';
import 'package:woosignal/models/response/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartModel extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;
  int productQty = 0;

  double get totalPrice {
    double total = 0.0;
    for (var item in _cartItems) {
      try {
        total += double.parse(item.product.price ?? '0') * item.quantity;
      } catch (e) {
        // Handle parsing error by skipping the item or logging the error
        print("Error parsing price: ${item.product.price}");
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

  void addToCart(Product product, {int quantity = 1}) {
    // Check if the product is already in the cart
    print(product.id);
    final existingItem = _cartItems.firstWhere(
          (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product),
    );

    if (_cartItems.contains(existingItem)) {
      // If the product is already in the cart, update its quantity
      existingItem.quantity = quantity;
    } else {
      // If not, add the product to the cart with the specified quantity
      _cartItems.add(CartItem(product: product, quantity: quantity));
      existingItem.quantity = quantity;
    }

    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
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
