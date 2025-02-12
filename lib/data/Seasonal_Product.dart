import 'package:achieveclubmobileclient/data/Seasonal_Variant.dart';

class SeasonalProduct {
  final int id;
  final String category;
  final String title;
  final int price;
  final List<SeasonalVariant> variants;

  SeasonalProduct({
    required this.id,
    required this.category,
    required this.title,
    required this.price,
    required this.variants,
  });

  factory SeasonalProduct.fromJson(Map<String, dynamic> json) {
    return SeasonalProduct(
      id: json['id'],
      category: json['type'],
      title: json['title'],
      price: json['price'],
      variants: (json['variants'] as List<dynamic>)
          .map((variantJson) => SeasonalVariant.fromJson(variantJson))
          .toList() ?? [],
    );
  }
}
