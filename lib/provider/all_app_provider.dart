import 'package:flutter/widgets.dart';
import 'package:woosignal/models/response/product_review.dart';
import 'package:woosignal/woosignal.dart';

import '../models/create_product_review_model.dart';

class AllAppProvider extends ChangeNotifier {
  ProductReview? _latestReview;

  ProductReview? get latestReview => _latestReview;
  Future<void> ProductReviewMethod(
      int productId, String status, String reviewer, String reviewerEmail, String review, int rating, bool verified) async {
    try {
      ProductReview? productReview = await WooSignal.instance.createProductReview(
        productId: productId,
        status: status,
        reviewer: reviewer,
        reviewerEmail: reviewerEmail,
        review: review,
        rating: rating,
        verified: verified,
      );

      if (productReview != null) {
          _latestReview=productReview;
        print("Rating: ${productReview.rating.toString()}");
        print("review: ${productReview.review.toString()}");

      } else {
        print("Product review creation failed. Response was null.");
      }
    } catch (e) {
      print("Error occurred while creating product review: $e");
    }
  }

  int productRating  = 0;
    updateProductRating (int value) {
      productRating=value;
      notifyListeners();
    }

}