import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/core/error/failures.dart';
import 'package:smart_health_care/core/usecases/app_usecases.dart';
import 'package:smart_health_care/features/auth/data/repositories/auth_repository.dart';
import 'package:smart_health_care/features/auth/domain/entities/auth_entity.dart';
import 'package:smart_health_care/features/auth/domain/repositories/auth_repository.dart';

class RegisterParams extends Equatable {
 
  final String email;
  final String password;
  

  const RegisterParams({
   
    required this.email,
    required this.password,
   
  });

  @override
  List<Object?> get props => [
    
    email,
    password,
    
  ];
}

// Create Provider
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase implements UsecaseWithParms<bool, RegisterParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterParams params) {
    final authEntity = AuthEntity(
      
      email: params.email,
      password: params.password,
      
    );

    return _authRepository.register(authEntity);
  }
}