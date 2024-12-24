class CreateProductReview {
  final int productId;
  final String status;
  final String reviewer;
  final String reviewerEmail;
  final String review;
  final int rating;
  final bool verified;

  // Constructor
  CreateProductReview({
    required this.productId,
    required this.status,
    required this.reviewer,
    required this.reviewerEmail,
    required this.review,
    required this.rating,
    required this.verified,
  });

  // Factory constructor for creating an instance from JSON
  factory CreateProductReview.fromJson(Map<String, dynamic> json) {
    return CreateProductReview(
      productId: json['product_id'],
      status: json['status'],
      reviewer: json['reviewer'],
      reviewerEmail: json['reviewer_email'],
      review: json['review'],
      rating: json['rating'],
      verified: json['verified'],
    );
  }

  // Method for converting the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'status': status,
      'reviewer': reviewer,
      'reviewer_email': reviewerEmail,
      'review': review,
      'rating': rating,
      'verified': verified,
    };
  }
}
