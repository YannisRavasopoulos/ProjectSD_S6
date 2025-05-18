import 'dart:math';

class User {
  int id;
  String firstName;
  String lastName;
  String email;
  String password;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  factory User.dummy() {
    return User(
      id: 1,
      firstName: "John",
      lastName: "Doe",
      email: "johndoe@example.com",
      password: "password123",
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
  }
}

class UserProfile extends User {
  String phoneNumber;
  String bio;

  UserProfile({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required this.phoneNumber,
    required this.bio,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
        );

  factory UserProfile.dummy() {
    return UserProfile(
      id: 1,
      firstName: "John",
      lastName: "Doe",
      email: "johndoe@example.com",
      password: "password123",
      phoneNumber: "+1234567890",
      bio: "Software Engineer and Flutter enthusiast.",
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'phoneNumber': phoneNumber,
      'bio': bio,
    });
    return json;
  }
}

class UserAddress {
  String street;
  String city;
  String state;
  String zipCode;

  UserAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  factory UserAddress.dummy() {
    return UserAddress(
      street: "123 Main Street",
      city: "Springfield",
      state: "IL",
      zipCode: "62704",
    );
  }
}

class UserPreferences {
  bool receiveNotifications;
  String theme;

  UserPreferences({
    required this.receiveNotifications,
    required this.theme,
  });

  factory UserPreferences.dummy() {
    return UserPreferences(
      receiveNotifications: true,
      theme: "Dark",
    );
  }
}
