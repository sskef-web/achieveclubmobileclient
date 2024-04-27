class Achievement {
  final int id;
  final int xp;
  final String title;
  final String description;
  final String logoURL;
  final bool isMultiple;

  Achievement({
    required this.id,
    required this.xp,
    required this.title,
    required this.description,
    required this.logoURL,
    required this.isMultiple,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      xp: json['xp'],
      title: json['title'],
      description: json['description'],
      logoURL: json['logoURL'],
      isMultiple: json['isMultiple'],
    );
  }

}