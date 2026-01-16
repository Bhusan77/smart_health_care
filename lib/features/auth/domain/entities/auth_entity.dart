import 'package:equatable/equatable.dart';


class AuthEntity extends Equatable {
  final String? authId;
  final String? username;
  final String email;
  final String? password;
 
  const AuthEntity({
    this.username,
    this.authId,
    required this.email,
    this.password,
    
  });

  @override
  List<Object?> get props => [
    username,
    authId,
    email,
    password,
   
  ];
}