class User {
  String userName;
  String firstName;
  String lastName;
  String email;
  DateTime birthDate;
  String DNI;
  int capacity;

  User(
    this.userName,
    this.firstName,
    this.lastName,
    this.email,
    this.birthDate,
    this.DNI,
    this.capacity
  );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['userName'] as String,
      json['firstName'] as String,
      json['lastName'] as String,
      json['email'] as String,
      DateTime.parse(json['birthDate'] as String), // Parse birthDate string to DateTime
      json['dni'] as String,
      json['capacity'] as int
    );
  }
}