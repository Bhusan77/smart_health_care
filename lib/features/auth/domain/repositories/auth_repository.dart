import 'package:dartz/dartz.dart';
import 'package:smart_health_care/core/error/failures.dart';
import 'package:smart_health_care/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity authEntity);
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, bool>> logout(String userId);
  Future<Either<Failure, AuthEntity>> getCurrentUser(String userId);
}