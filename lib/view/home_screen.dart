import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:green_commerce/view/product_detail.dart';
import 'package:green_commerce/repository/apis_call.dart';
import 'package:provider/provider.dart';
import 'package:woosignal/models/response/customer.dart';
import 'package:woosignal/models/response/customer_batch.dart';
import 'package:woosignal/models/response/product.dart';
import 'package:woosignal/models/response/product_category.dart';
import 'package:woosignal/woosignal.dart';

import '../models/cart_model.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductCategory> _categories = [];
  List<Product> _products = [];
  List<Customer> _customers = [];
  bool _isLoading = true;
  final int cartItemCount = 5; // Replace this with your dynamic cart count.
  Future<void> _initializeWooSignal() async {
    try {
      // Initialize WooSignal once
      await WooSignal.instance
          .init(appKey: "app_7783c0966547d618955b5223e22540");

      // Fetch data
      List<ProductCategory>? categories =
      await WooSignal.instance.getProductCategories();
      List<Product>? product = await WooSignal.instance.getProducts();
      List<Customer>? customers = await WooSignal.instance.getCustomers();
      print('here are product${_customers.length}');

      setState(() {
        _categories = categories ?? [];
        _products = product ?? [];
        _customers= customers??[];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error initializing WooSignal: $e");
    }
  }
@override
void initState() {
    // TODO: implement initState
   _initializeWooSignal();
    super.initState();
  }
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: InkWell(
              onTap: () async{
               await CallWooSignal().getPaymentGateways();
              },
            child: const Text("Green Store", style: TextStyle(color: Colors.black),)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Cart icon with item count
          Consumer<CartModel>(
            builder: (context, cartModel, child) {
              int cartItemCount = cartModel.cartItems.length;
              int totalqty  = cartModel.totalQuantity;
              return IconButton(
                icon: Stack(
                  children: [
                    Icon(Icons.shopping_cart, size: 30,color: Colors.black,),
                    if (cartItemCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            '$totalqty',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
              );
            },
          ),

        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 200, // Adjust the height of the carousel
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index, realIndex) {
                  final category = _categories[index];
                  return Stack(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: category.image != null &&
                              category.image!.src != null
                              ? Image.network(
                            category.image!.src!,
                            height:
                            200, // Match the carousel height
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                              : const Center(
                            child: Icon(
                              Icons.category,
                              size: 80,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom:
                        10, // Position near the bottom of the card
                        left: 10, // Add some padding from the left
                        right: 10, // Add padding from the right
                        child: Container(
                          color: Colors.white.withOpacity(0.8),
                          // Add a translucent background
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Text(
                            category.name ?? "Unnamed",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Products",
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                padding: const EdgeInsets.all(16),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: _products!.length,
                itemBuilder: (context, index) {
                  Product product = _products![index];
                  return ProductCard(product: product);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailPage(product: product)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
                image: product.images != null && product.images!.isNotEmpty
                    ? DecorationImage(
                  image: NetworkImage(product.images![0].src!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            product.name!,
            style: TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          RatingBar.builder(
            initialRating: product.ratingCount!.toDouble() ?? 0.0,
            minRating: 0,
            itemSize: 14,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal:0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
          // Text(
          //   product.ratingCount.toString() ?? "Unknown",
          //   style: TextStyle(color: Colors.grey),
          // ),
          SizedBox(height: 4),
          Text(
            "\$${product.price}",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ],
      ),
    );
  }
}

