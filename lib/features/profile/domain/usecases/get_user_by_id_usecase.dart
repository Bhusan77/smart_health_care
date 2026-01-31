import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/core/error/failures.dart';
import 'package:smart_health_care/core/usecases/app_usecases.dart';
import 'package:smart_health_care/features/profile/data/repositories/profile_repository.dart';
import 'package:smart_health_care/features/profile/domain/entities/profile_entity.dart';
import 'package:smart_health_care/features/profile/domain/repositories/profile_repository.dart';

class GetUserByIdUsecaseParams extends Equatable {
  final String userId;

  const GetUserByIdUsecaseParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final getUserByIdUsecaseProvider = Provider<GetUserByIdUsecase>((ref) {
  final profileRepository = ref.read(profileRepositoryProvider);
  return GetUserByIdUsecase(profileRepository: profileRepository);
});

class GetUserByIdUsecase
    implements UsecaseWithParms<ProfileEntity?, GetUserByIdUsecaseParams> {
  final IProfileRepository _profileRepository;

  GetUserByIdUsecase({required IProfileRepository profileRepository})
    : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, ProfileEntity?>> call(GetUserByIdUsecaseParams params) {
    return _profileRepository.getUserById(params.userId);
  }
}