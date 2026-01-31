import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/core/error/failures.dart';
import 'package:smart_health_care/core/usecases/app_usecases.dart';
import 'package:smart_health_care/features/profile/data/repositories/profile_repository.dart';
import 'package:smart_health_care/features/profile/domain/entities/profile_entity.dart';
import 'package:smart_health_care/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfileUsecaseParams extends Equatable {
  final String? username;
  final String? password;
  final File? profile;

  const UpdateProfileUsecaseParams({
    this.username,
    this.password,
    this.profile,
  });

  @override
  List<Object?> get props => [
   username,
   password,
   profile,
  ];
}

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  final profileRepository = ref.read(profileRepositoryProvider);
  return UpdateProfileUsecase(profileRepository: profileRepository);
});

class UpdateProfileUsecase
    implements UsecaseWithParms<bool, UpdateProfileUsecaseParams> {
  final IProfileRepository _profileRepository;

  UpdateProfileUsecase({required IProfileRepository profileRepository})
    : _profileRepository = profileRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateProfileUsecaseParams params) {
    final profileEntity = ProfileEntity(
      username:params.username,
      password:params.password,
      profile: params.profile,
    );
    return _profileRepository.updateProfile(profileEntity);
  }
}