import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/features/dashboard/presentation/state/profile_state.dart';
import 'package:smart_health_care/features/profile/domain/usecases/get_user_by_id_usecase.dart';
import 'package:smart_health_care/features/profile/domain/usecases/update_profile_usecase.dart';

final profileViewModelProvider =
    NotifierProvider<ProfileViewModel, ProfileState>(() => ProfileViewModel());

class ProfileViewModel extends Notifier<ProfileState> {
  late final UpdateProfileUsecase _updateProfileUsecase;
  late final GetUserByIdUsecase _getUserByIdUsecase;

  @override
  ProfileState build() {
    _updateProfileUsecase = ref.read(updateProfileUsecaseProvider);
    _getUserByIdUsecase = ref.read(getUserByIdUsecaseProvider);
    return const ProfileState();
  }

  Future<void> updateProfile({
    String? username,
    String? password,
    File? profile,
  }) async {
    print("updateProfile called");
    print("username: $username");
    print("password: $password");
    print("profile path: ${profile?.path}");

    state = state.copyWith(
      status: ProfileStatus.loading,
      errorMessage: null,
    );

    final params = UpdateProfileUsecaseParams(
      username: username,
      password: password,
      profile: profile,
    );

    final result = await _updateProfileUsecase(params);

    print("updateProfile result: $result");

    result.fold(
      (failure) {
        print("update failed: ${failure.message}");
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (isUpdated) {
        print("isUpdated: $isUpdated");
        if (isUpdated) {
          state = state.copyWith(
            status: ProfileStatus.updated,
            errorMessage: null,
          );
          print("state changed to updated");
        } else {
          state = state.copyWith(
            status: ProfileStatus.error,
            errorMessage: "Profile update failed",
          );
          print("state changed to error");
        }
      },
    );
  }

  Future<void> getProfileById({required String userId}) async {
    state = state.copyWith(
      status: ProfileStatus.loading,
      errorMessage: null,
    );

    final params = GetUserByIdUsecaseParams(userId: userId);
    final result = await _getUserByIdUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        if (user != null) {
          state = state.copyWith(
            status: ProfileStatus.loaded,
            user: user,
            errorMessage: null,
          );
        } else {
          state = state.copyWith(
            status: ProfileStatus.error,
            errorMessage: "User not found",
          );
        }
      },
    );
  }
}