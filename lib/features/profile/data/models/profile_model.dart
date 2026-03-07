import 'dart:io';
import 'package:smart_health_care/features/profile/domain/entities/profile_entity.dart';

class ProfileModel {
  String? userId;
  String? username;
  File? profile;
  String? password;
  final String? profilePicture;

  ProfileModel({
    this.userId,
    this.username,
    this.profile,
    this.password,
    this.profilePicture,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: json['_id']?.toString(),
      username: json['username']?.toString(),
      password: json['password']?.toString(),
      profilePicture: json['profile']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (userId != null) json['_id'] = userId;
    if (profile != null) json['profile'] = profile;
    if (password != null) json['password'] = password;
    if (username != null) json['username'] = username;
    if (profilePicture != null) json['profile'] = profilePicture;

    return json;
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      userId: userId,
      username: username,
      profilePicture: profilePicture,
    );
  }

  static ProfileModel fromEntity(ProfileEntity entity) {
    return ProfileModel(
      userId: entity.userId,
      username: entity.username,
      profile: entity.profile,
      profilePicture: entity.profilePicture,
    );
  }
}