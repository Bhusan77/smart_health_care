import 'dart:io';

import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String? userId;
  final String? username;
  final String? password;
  final File? profile;
  final String? profilePicture;
  

  const ProfileEntity({
    this.userId,
    this.username,
    this.password,
    this.profile,
    this.profilePicture,
    
  });

  @override
  List<Object?> get props => [
        userId,
        username,
        password,
        profile,
        profilePicture,
      ];
}