class Photo {
  final String url;

  Photo({
    required this.url,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      url: json['url'],
    );
  }
}