import 'package:achieveclubmobileclient/data/Variant.dart';

class ProductData {
  final int id;
  final String type;
  final String title;
  final int price;
  final String details;
  final List<Variant> variants;

  ProductData({
    required this.id,
    required this.type,
    required this.title,
    required this.price,
    required this.details,
    required this.variants,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      price: json['price'],
      details: json['details'],
      variants: (json['variants'] as List).map((variantJson) => Variant.fromJson(variantJson)).toList(),
    );
  }
}