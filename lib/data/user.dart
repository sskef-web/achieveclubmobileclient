class User {
  final int id;
  final String firstName;
  final String lastName;
  final String avatar;
  final int clubId;
  final String clubName;
  final String clubLogo;
  final int xpSum;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.clubId,
    required this.clubName,
    required this.clubLogo,
    required this.xpSum
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatar: json['avatar'],
      clubId: json['clubId'],
      clubName: json['clubName'],
      clubLogo: json['clubLogo'],
      xpSum: json['xpSum'],
    );
  }
}