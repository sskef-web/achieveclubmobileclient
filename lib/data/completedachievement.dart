class CompletedAchievement {
  final int achievementId;

  CompletedAchievement({
    required this.achievementId,
  });

  factory CompletedAchievement.fromJson(Map<String, dynamic> json) {
    return CompletedAchievement(
      achievementId: json['achieveId'],
    );
  }
}

CompletedAchievement findElementWithMaxId(List<CompletedAchievement> elements) {
  if (elements.isEmpty) {
    throw Exception("Lista jest pusta!");
  }

  CompletedAchievement elementWithMaxId = elements[0];

  for (var element in elements) {
    if (element.achievementId > elementWithMaxId.achievementId) {
      elementWithMaxId = element;
    }
  }

  return elementWithMaxId;
}