import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_commerce/models/product_model.dart';
import 'package:green_commerce/provider/all_app_provider.dart';
import 'package:green_commerce/repository/apis_call.dart';
import 'package:green_commerce/view/widgets/text_field.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:woosignal/models/response/product.dart';
import 'package:provider/provider.dart';
import 'package:woosignal/models/response/product_review.dart';
import 'package:woosignal/models/response/product_variation.dart';
import 'package:woosignal/woosignal.dart';

import '../models/cart_model.dart';
import '../user_authentication/auth_service_provider.dart';
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
  final TextEditingController reviewController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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
              return Row(
                children: [
                  IconButton(
                    icon: Stack(
                      children: [
                        const Icon(
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
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                '$totalqty',
                                style: const TextStyle(
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
                  ),
                  IconButton(onPressed: ()async{
                    final provider =Provider.of<AuthServiceProvider>(context,listen: false);
                    await provider.clearToken(context);

                  }, icon: Icon(Icons.logout_outlined,color: Colors.black,size: 30,))
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<CartModel>(
          builder: (BuildContext context, cartModel, Widget? child) {
            final provider  = Provider.of<AllAppProvider>(context,listen: false);
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
                        style: const TextStyle(
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
                        height: 500,
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
                            Consumer <AllAppProvider>(

                              builder: (BuildContext context, value, Widget? child) {
                                return Column(
                                  children: [
                                    value.latestReview!=null?
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            child: Image.asset('assets/images/logo3.png'),
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                                            children: [
                                              const Text('Your review is awaiting approval'),
                                              Text(value.latestReview!.review.toString()),

                                              // Display stars based on the rating
                                              Row(
                                                children: List.generate(5, (index) {
                                                  // Check if the current index is less than the rating
                                                  bool isFilled = index < value.latestReview!.rating!.toInt();
                                                  return Icon(
                                                    Icons.star,
                                                    color: isFilled ? Colors.yellow : Colors.grey, // Yellow if filled, grey otherwise
                                                    size: 20.0,
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                        :
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          'No reviews yet.',
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.grey[700]),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Align(
                                              alignment: Alignment.topLeft,
                                              child: Text('Be the first to review "Bird Of Paradise"')),
                                          const Row(
                                            children: [
                                              Text('Your Rating*'),
                                              StarRatingWidget(),
                                            ],
                                          ),
                                          SizedBox(height: 20,),
                                          SizedBox(
                                            width: double.infinity,
                                            height: 80,
                                            child: TextField(
                                              controller: reviewController,
                                              maxLines: 5, // Specifies the height of the text area
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(), // Adds a border around the text area
                                                labelText: 'Enter your review', // Placeholder or label
                                                hintText: 'Write your review here...',
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20,),
                                          Row(
                                            children: [
                                              GlobalTextField(name: 'Name', controller: nameController),
                                              GlobalTextField(name: 'Email', controller: emailController),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          value.reviewLoading ?
                                              Center(child: CircularProgressIndicator(color: Colors.black,)):
                                          Align(
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              onTap: () async{
                                                final provider  = Provider.of<AllAppProvider>(context,listen: false);
                                                if(provider.productRating==0){
                                                  MotionToast.error(
                                                    title:  Text("Failed"),
                                                    description:  Text("Please add some rating"),
                                                  ).show(context);

                                                }else if(reviewController.text.isEmpty){
                                                  MotionToast.error(
                                                    title:  Text("Failed"),
                                                    description:  Text("Please add review"),
                                                  ).show(context);

                                                }
                                                else if (nameController.text.isEmpty){
                                                  MotionToast.error(
                                                    title:  Text("Failed"),
                                                    description:  Text("Please add name"),
                                                  ).show(context);
                                                }else if (emailController.text.isEmpty){
                                                  MotionToast.error(
                                                    title:  Text("Failed"),
                                                    description:  Text("Please add email"),
                                                  ).show(context);
                                                }
                                                else{
                                                  var review = await provider.ProductReviewMethod(productDetail!.productId??0, 'approved',nameController.text , emailController.text, reviewController.text, provider.productRating, false,context);
                                                  emailController.clear();
                                                  nameController.clear();
                                                  reviewController.clear();
                                                   FocusScope.of(context).unfocus();
                                                  // CallWooSignal().addReview(productId: productDetail!.productId??0, reviewer: 'wajahat', reviewerEmail: 'oso.wajahatullah@gmail.com', review:reviewController.text , rating: provider.productRating);
                                                  print({review});
                                                }

                                              },
                                              child: Container(
                                                width: 300,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius: BorderRadius.circular(7)
                                                ),
                                                child: Center(child: Text('Submit', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                              ),
                                            ),
                                          ),



                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
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
class StarRatingWidget extends StatefulWidget {
  const StarRatingWidget({Key? key}) : super(key: key);

  @override
  _StarRatingWidgetState createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  int _selectedRating = 0;

  // Method to handle star click
  void _onStarTap(int index) {
    setState(() {
      _selectedRating = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: (){
            final provider  = Provider.of<AllAppProvider>(context,listen: false);
            _onStarTap(index + 1);
            provider.updateProductRating(_selectedRating);

          },
          child: Icon(
            Icons.star,
            color: index < _selectedRating ? Colors.amber : Colors.grey,
            size: 30,
          ),
        );
      }),
    );
  }
}