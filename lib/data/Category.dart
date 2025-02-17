class Category {
  final int id;
  final String title;
  final String color;

  Category({required this.id, required this.title, required this.color});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      color: json['color'],
    );
  }
}
