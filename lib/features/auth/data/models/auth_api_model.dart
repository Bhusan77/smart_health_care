import 'package:smart_health_care/features/auth/domain/entities/auth_entity.dart';


class AuthApiModel {
  String? id;
  String?username;
  String? email;
  String? password;
 
  

  AuthApiModel({
    this.id,
     this.username,
     this.email,
    this.password,
    
    
  });

   factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id:json['_id'] as String?,
      email: json['email'] as String,
      password: json['password'] as String,
      username: json['username'] as String,
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'password': password,
      'username': username,
      
      
      
    };
  }

  // Entity conversion methods
  AuthEntity toEntity() {
    return AuthEntity(
      username:username,
      email: email!,
      password: password,
      
      
    );
  }

  static AuthApiModel fromEntity(AuthEntity entity) {
    return AuthApiModel(
      username: entity.username,
      email: entity.email,
      password: entity.password,
     
    );
  }
}