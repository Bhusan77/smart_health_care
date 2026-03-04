import 'package:smart_health_care/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String? username;
  final String? email;
  final String? password;

  AuthApiModel({
    this.id,
    this.username,
    this.email,
    this.password,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      // backend might return _id or id
      id: (json['_id'] ?? json['id'])?.toString(),

      // backend might return username or name
      username: json['username']?.toString() ?? json['name']?.toString(),

      // email should exist, but keep safe
      email: json['email']?.toString(),

      // password will usually NOT come from backend responses
      password: json['password']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  // ✅ Convert to entity safely
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      username: username,
      email: email ?? "", // prevent crash if backend sends null (rare)
      password: password, // optional, ok
    );
  }

  static AuthApiModel fromEntity(AuthEntity entity) {
    return AuthApiModel(
      id: entity.authId,
      username: entity.username,
      email: entity.email,
      password: entity.password,
    );
  }
}