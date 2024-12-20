import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_commerce/models/product_model.dart';
import 'package:green_commerce/repository/apis_call.dart';
import 'package:woosignal/models/response/product.dart';
import 'package:provider/provider.dart';
import 'package:woosignal/models/response/product_variation.dart';
import 'package:woosignal/woosignal.dart';

import '../models/cart_model.dart';
import 'cart_screen.dart';

class ProductDetailPage extends StatefulWidget {
  ProductDetailPage({super.key, required this.product});
   final Product product;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
  List<ProductVariation> _productVariation = [];
  bool isVariant = false;
  late ProductVariation productVariation;

  String? image;
  String? price;
  String? name;
  ProductDetail? productDetail; // Made nullable for later initialization

  @override
  void initState() {
    super.initState();
    getProductVariation();
    updateProductModel();// Fetch variations on init
  }

  // Increment quantity
  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  // Decrement quantity
  void _decrement() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
      }
    });
  }

  getProductVariation() async {
    try {
      List<ProductVariation> productVariation =
      await WooSignal.instance.getProductVariations(widget.product.id ?? 0);
      setState(() {
        _productVariation = productVariation;
      });
    } catch (e) {
      print("Error fetching product variations: $e");
    }
  }

  void updateProductModel() {
    // Initialize productDetail here (if it's not final, and can be updated)
    productDetail = ProductDetail(
      name: widget.product.name,
      productId: widget.product.id,
      price: widget.product.price,
      image: widget.product.images
          .map((image) =>
          Images.fromJson(image.toJson())) // Assuming this is correct mapping
          .toList(),
    );

    // Printing the updated price for debugging
    print(productDetail?.price);
    // Create a ProductModel using the updated productDetail
   // / Null check needed since it's nullable
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Consumer<CartModel>(
            builder: (context, cartModel, child) {
              int cartItemCount = cartModel.cartItems.length;
              int totalqty = cartModel.totalQuantity;
              return IconButton(
                icon: Stack(
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 30,
                      color: Colors.black,
                    ),
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
      body: SingleChildScrollView(
        child: Consumer<CartModel>(
          builder: (BuildContext context, cartModel, Widget? child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Image.network(

                      productDetail!.image![0]
                          .src!, // Replace with your image URL
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Product Title and Price
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name!,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _productVariation.length,
                        itemBuilder: (BuildContext context, int index) {
                           var variation = _productVariation[index];
                          return Row(
                            spacing: 10,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                      // Initialize productDetail here (if it's not final, and can be updated)
                                    productDetail = ProductDetail(
                                      name: widget.product.name,
                                      productId: variation.id,
                                      price: variation.price,
                                      image: variation.image != null
                                          ? [Images.fromJson(variation.image!.toJson())] // If it's a single Image object
                                          : [], // Return an empty list if image is null
                                    );

                                    // Printing the updated price for debugging
                                      print(productDetail?.price);
                                      // Create a ProductModel using the updated productDetail
                                      // / Null check needed since it's nullable

                                  });

                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.black, width: 1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                            child: Text(
                                              variation.attributes[0].option.toString(),
                                          style: TextStyle(fontSize: 15),
                                        )),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              Container()
                            ],
                          );
                        },
                      ),
                  SizedBox(height: 8),

                  // Row(
                      //   spacing: 10,
                      //   children: [
                      //     InkWell(
                      //       onTap: (){
                      //
                      //       },
                      //       child: Container(
                      //         width: 100,
                      //         height: 40,
                      //         decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           border: Border.all(color: Colors.black,width: 1),
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //         child: Center(child: Text('White',style: TextStyle(fontSize: 15),)),
                      //       ),
                      //     ),
                      //     Container(
                      //       width: 100,
                      //       height: 40,
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         border: Border.all(color: Colors.black,width: 1),
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       child: Center(child: Text('Black',style: TextStyle(fontSize: 15),)),
                      //     ),
                      //   ],
                      // ),

                      SizedBox(
                        height: 10,
                      ),
                      Text(

                        '\$${productDetail!.price.toString()} • Free Shipping',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.product.description!,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),

                // Add to Cart Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity Selector
                      Container(
                        // width: 130,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 10,
                          children: [
                            // Decrease Quantity Button
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                _quantity.toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                spacing: 0,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      _decrement();
                                    },
                                  ),
                                  // Quantity Display

                                  // Increase Quantity Button
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      _increment();
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 16),

                      // Add to Cart Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Add to cart action
                            Provider.of<CartModel>(context, listen: false)
                                .addToCart(productDetail!, quantity: _quantity);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Add to Cart',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Categories Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Categories: Ceramic pots, Large Plants, Plant bundle',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),

                SizedBox(height: 24),

                // Tabs Section (Description and Reviews)
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Colors.green,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.green,
                        tabs: [
                          Tab(text: 'Description'),
                          Tab(text: 'Reviews (0)'),
                        ],
                      ),
                      SizedBox(
                        height: 200,
                        child: TabBarView(
                          children: [
                            // Description Tab
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Faucibus lacus tincidunt molestie accumsan nibh non odio aenean molestie purus tristique sed tempor consequat risus tellus amet augue egestas mauris scelerisque donec ultrices.',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[700]),
                              ),
                            ),

                            // Reviews Tab
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'No reviews yet.',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
