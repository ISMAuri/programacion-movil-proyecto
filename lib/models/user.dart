import '../utils/json_utils.dart';

class User {
  final int? id;
  final String fullName;
  final String email;
  final String role;
  final bool isEmailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.isEmailVerified,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      isEmailVerified: jsonToBool(json['isEmailVerified']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'fullName': fullName, 'email': email, 'role': role};
  }
}
