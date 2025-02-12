class SeasonalVariant {
  final int id;
  final String color;
  final String photo;
  final bool available;

  SeasonalVariant({
    required this.id,
    required this.color,
    required this.photo,
    required this.available,
  });

  factory SeasonalVariant.fromJson(Map<String, dynamic> json) {
    return SeasonalVariant(
      id: json['id'],
      color: json['color'],
      photo: json['photo'],
      available: json['available'] ?? false,
    );
  }
}
