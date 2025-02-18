class CompletedAchievement {
  final int achievementId;
  final int completionCount;
  final int? nextTryUnix;

  CompletedAchievement({
    required this.achievementId,
    required this.completionCount,
    required this.nextTryUnix
  });

  factory CompletedAchievement.fromJson(Map<String, dynamic> json) {
    return CompletedAchievement(
      achievementId: json['achieveId'],
      completionCount: json['completionCount'],
        nextTryUnix: json['nextTryUnix']
    );
  }
}

CompletedAchievement findElementWithMaxId(List<CompletedAchievement> elements) {
  if (elements.isEmpty) {
    throw Exception("List is empty");
  }

  CompletedAchievement elementWithMaxId = elements[0];

  for (var element in elements) {
    if (element.achievementId > elementWithMaxId.achievementId) {
      elementWithMaxId = element;
    }
  }

  return elementWithMaxId;
}