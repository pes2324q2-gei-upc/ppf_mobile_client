class User {
  int id;
  String username;
  String email;
  DateTime birthDate;

  User(
    this.id,
    this.username,
    this.email,
    this.birthDate,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'] as int,
      json['username'] as String,
      json['email'] as String,
      DateTime.parse(
          json['birthDate'] as String), // Parse birthDate string to DateTime
    );
  }
}