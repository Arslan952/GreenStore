

class ReviewModel {
  final int? id;
  final String? dateCreated;
  final String? dateCreatedGmt;
  final int? productId;
  final String? productName;
  final String? productPermalink;
  final String? status;
  final String? reviewer;
  final String? reviewerEmail;
  final String? review;
  final int? rating;
  final bool? verified;
  final ReviewerAvatarUrls? reviewerAvatarUrls;
  final Links? links;

  ReviewModel({
    this.id,
    this.dateCreated,
    this.dateCreatedGmt,
    this.productId,
    this.productName,
    this.productPermalink,
    this.status,
    this.reviewer,
    this.reviewerEmail,
    this.review,
    this.rating,
    this.verified,
    this.reviewerAvatarUrls,
    this.links,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as int?,
      dateCreated: json['date_created'] as String?,
      dateCreatedGmt: json['date_created_gmt'] as String?,
      productId: json['product_id'] as int?,
      productName: json['product_name'] as String?,
      productPermalink: json['product_permalink'] as String?,
      status: json['status'] as String?,
      reviewer: json['reviewer'] as String?,
      reviewerEmail: json['reviewer_email'] as String?,
      review: json['review'] as String?,
      rating: json['rating'] as int?,
      verified: json['verified'] as bool?,
      reviewerAvatarUrls: json['reviewer_avatar_urls'] != null
          ? ReviewerAvatarUrls.fromJson(
          json['reviewer_avatar_urls'] as Map<String, dynamic>)
          : null,
      links: json['_links'] != null
          ? Links.fromJson(json['_links'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_created': dateCreated,
      'date_created_gmt': dateCreatedGmt,
      'product_id': productId,
      'product_name': productName,
      'product_permalink': productPermalink,
      'status': status,
      'reviewer': reviewer,
      'reviewer_email': reviewerEmail,
      'review': review,
      'rating': rating,
      'verified': verified,
      'reviewer_avatar_urls': reviewerAvatarUrls?.toJson(),
      '_links': links?.toJson(),
    };
  }
}

class ReviewerAvatarUrls {
  final String? s24;
  final String? s48;
  final String? s96;

  ReviewerAvatarUrls({this.s24, this.s48, this.s96});

  factory ReviewerAvatarUrls.fromJson(Map<String, dynamic> json) {
    return ReviewerAvatarUrls(
      s24: json['24'] as String?,
      s48: json['48'] as String?,
      s96: json['96'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '24': s24,
      '48': s48,
      '96': s96,
    };
  }
}

class Links {
  final List<LinkItem>? self;
  final List<LinkItem>? collection;
  final List<LinkItem>? up;

  Links({this.self, this.collection, this.up});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      self: (json['self'] as List?)
          ?.map((item) => LinkItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      collection: (json['collection'] as List?)
          ?.map((item) => LinkItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      up: (json['up'] as List?)
          ?.map((item) => LinkItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'self': self?.map((item) => item.toJson()).toList(),
      'collection': collection?.map((item) => item.toJson()).toList(),
      'up': up?.map((item) => item.toJson()).toList(),
    };
  }
}

class LinkItem {
  final String? href;
  final TargetHints? targetHints;

  LinkItem({this.href, this.targetHints});

  factory LinkItem.fromJson(Map<String, dynamic> json) {
    return LinkItem(
      href: json['href'] as String?,
      targetHints: json['targetHints'] != null
          ? TargetHints.fromJson(json['targetHints'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'href': href,
      'targetHints': targetHints?.toJson(),
    };
  }
}

class TargetHints {
  final List<String>? allow;

  TargetHints({this.allow});

  factory TargetHints.fromJson(Map<String, dynamic> json) {
    return TargetHints(
      allow: (json['allow'] as List?)?.map((item) => item as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allow': allow,
    };
  }
}
