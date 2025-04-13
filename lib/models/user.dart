// lib/models/user.dart
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String postalCode;
  final String state;
  final String country;
  final String avatar;
  final String status;
  final String? token;
  final String company;
  final String role;
  final List<String> permissions;
  final String? signature;
  final String timezone;
  final String language;
  final String initiateStatus;
  final String? dateOfBirth;
  final String? age;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.state,
    required this.country,
    required this.avatar,
    required this.status,
    this.token,
    required this.company,
    required this.role,
    required this.permissions,
    this.signature,
    required this.timezone,
    required this.language,
    required this.initiateStatus,
    this.dateOfBirth,
    this.age,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      firstName: json['fname']?.toString() ?? '',
      lastName: json['lname']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      postalCode: json['postalcode']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      token: json['token']?.toString(),
      company: json['company']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      permissions: List<String>.from(json['permissions'] != null
          ? json['permissions']
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '')
              .split(',')
          : []),
      signature: json['signature']?.toString(),
      timezone: json['timezone']?.toString() ?? '',
      language: json['lang']?.toString() ?? '',
      initiateStatus: json['initiate_status']?.toString() ?? '',
      dateOfBirth: json['dob']?.toString(),
      age: json['age']?.toString(),
    );
  }

  String get fullName => '$firstName $lastName';
}
