class Achievement {
  final int id;
  final int xp;
  final String title;
  final String description;
  final String logoURL;
  // final int completionRatio;
  final bool isMultiple;

  Achievement({
    required this.id,
    required this.xp,
    required this.title,
    required this.description,
    required this.logoURL,
    // required this.completionRatio,
    required this.isMultiple
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      xp: json['xp'],
      title: json['title'],
      description: json['description'],
      logoURL: json['logoURL'],
      // completionRatio: json['completionRatio'],
      isMultiple: json['isMultiple']
    );
  }

}
