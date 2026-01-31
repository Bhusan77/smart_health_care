import 'package:dartz/dartz.dart';
import 'package:smart_health_care/core/error/failures.dart';
import 'package:smart_health_care/features/profile/domain/entities/profile_entity.dart';

abstract interface class IProfileRepository {
  Future<Either<Failure, bool>> updateProfile(ProfileEntity updatedData);
  Future<Either<Failure, ProfileEntity?>> getUserById(String userId);
}
