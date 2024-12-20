class ProductDetail {
  String?name;
  int? productId;
  String? price;
  List<Images>? image;

  // Constructor
  ProductDetail({
    required this.productId,
    required this.price,
    required this.image,
    required this.name
  });

  // Factory constructor for JSON deserialization
  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      productId: json['productId'] as int?,
      price: json['price'] as String?,
      name: json['name']as String,
      image: (json['image'] as List<dynamic>?)
          ?.map((e) => Images.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() => {
    'productId': productId,
    'price': price,
     'name':name,
    'image': image?.map((e) => e.toJson()).toList(),
  };
}

class Images {
  int? id;
  DateTime? dateCreated;
  DateTime? dateCreatedGMT;
  DateTime? dateModified;
  DateTime? dateModifiedGMT;
  String? src;
  String? name;
  String? alt;

  Images(this.id, this.src, this.name, this.alt, this.dateCreated,
      this.dateCreatedGMT, this.dateModified, this.dateModifiedGMT);

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    src = (json['src'] is String ? json['src'] : json['src'].toString());
    name = json['name'];
    alt = json['alt'];
    if (json['date_created'] != null) {
      dateCreated = DateTime.parse(json['date_created'].toString());
    }
    if (json['date_modified_gmt'] != null) {
      dateModifiedGMT = DateTime.parse(json['date_modified_gmt'].toString());
    }
    if (json['date_modified'] != null) {
      dateModified = DateTime.parse(json['date_modified'].toString());
    }
    if (json['date_created_gmt'] != null) {
      dateCreatedGMT = DateTime.parse(json['date_created_gmt'].toString());
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'src': src,
    'name': name,
    'alt': alt,
    'date_created': dateCreated,
    'date_modified_gmt': dateModifiedGMT,
    'date_modified': dateModified,
    'date_created_gmt': dateCreatedGMT
  };
}
class ProductModel {
  final ProductDetail? productDetail;  // Nullable field

  ProductModel({this.productDetail});  // Can be assigned null or a valid ProductDetail
}
