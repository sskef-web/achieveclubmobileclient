import 'package:achieveclubmobileclient/data/Photo.dart';

class Variant {
  final int id;
  final String title;
  final String color;
  final List<Photo> photos;
  final bool isAvailable;

  Variant({
    required this.id,
    required this.title,
    required this.color,
    required this.photos,
    required this.isAvailable
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      title: json['title'],
      color: json['color'],
      photos: (json['photos'] as List).map((photoJson) => Photo.fromJson(photoJson)).toList(),
      isAvailable: json['available']
    );
  }

}