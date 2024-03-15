// ignore_for_file: file_names

class User {
  String userName;
  String firstName;
  String lastName;
  String email;
  DateTime birthDate;

  User(
    this.userName,
    this.firstName,
    this.lastName,
    this.email,
    this.birthDate,
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['userName'] as String,
      json['firstName'] as String,
      json['lastName'] as String,
      json['email'] as String,
      DateTime.parse(
          json['birthDate'] as String), // Parse birthDate string to DateTime
    );
  }
}
