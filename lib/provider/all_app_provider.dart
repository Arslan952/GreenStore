import 'package:flutter/widgets.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:woosignal/models/response/product_review.dart';
import 'package:woosignal/woosignal.dart';

import '../models/create_product_review_model.dart';
import '../models/reviewModel.dart';

class AllAppProvider extends ChangeNotifier {
  ProductReview? _latestReview;

  ProductReview? get latestReview => _latestReview;
  Future<void> ProductReviewMethod(
      int productId, String status, String reviewer, String reviewerEmail, String review, int rating, bool verified,BuildContext context) async {
    try {
      updateReviewLoading(true);
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
          MotionToast.success(
            title:  Text("Success"),
            description:  Text("Review has been added"),
          ).show(context);

          updateReviewLoading(false);

      } else {
        print("Product review creation failed. Response was null.");
        updateReviewLoading(false);
      }
    } catch (e) {
      print("Error occurred while creating product review: $e");
      updateReviewLoading(false);

    }
    notifyListeners();
  }

  int productRating  = 0;
    updateProductRating (int value) {
      productRating=value;
      print(value);
      notifyListeners();
    }

    bool reviewLoading  = false;
    updateReviewLoading  (bool value){
      reviewLoading=value;
      notifyListeners();
    }


  //Get Review
  bool isReviewLoad=false;

    updateReviewLoad(bool data)
    {
      isReviewLoad=data;
      notifyListeners();
    }

  List<ReviewModel>reviewData=[];
    updateReviewModel(List<ReviewModel>data)
    {
      reviewData=data;
      notifyListeners();
    }

    //Create Order
bool isOrdercreating=false;
    updateOrderCreating(bool data)
    {
      isOrdercreating=data;
      notifyListeners();
    }


}