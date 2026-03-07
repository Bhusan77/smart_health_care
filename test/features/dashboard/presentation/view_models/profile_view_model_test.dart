import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/core/error/failures.dart';
import 'package:smart_health_care/features/dashboard/presentation/state/profile_state.dart';
import 'package:smart_health_care/features/dashboard/presentation/view_models/profile_view_model.dart';
import 'package:smart_health_care/features/profile/domain/entities/profile_entity.dart';
import 'package:smart_health_care/features/profile/domain/usecases/get_user_by_id_usecase.dart';
import 'package:smart_health_care/features/profile/domain/usecases/update_profile_usecase.dart';

class MockUpdateProfileUsecase extends Mock implements UpdateProfileUsecase {}

class MockGetUserByIdUsecase extends Mock implements GetUserByIdUsecase {}

class FakeUpdateProfileUsecaseParams extends Fake
    implements UpdateProfileUsecaseParams {}

class FakeGetUserByIdUsecaseParams extends Fake
    implements GetUserByIdUsecaseParams {}

void main() {
  late ProviderContainer container;
  late MockUpdateProfileUsecase mockUpdateProfileUsecase;
  late MockGetUserByIdUsecase mockGetUserByIdUsecase;

  setUpAll(() {
    registerFallbackValue(FakeUpdateProfileUsecaseParams());
    registerFallbackValue(FakeGetUserByIdUsecaseParams());
  });

  setUp(() {
    mockUpdateProfileUsecase = MockUpdateProfileUsecase();
    mockGetUserByIdUsecase = MockGetUserByIdUsecase();

    container = ProviderContainer(
      overrides: [
        updateProfileUsecaseProvider.overrideWithValue(
          mockUpdateProfileUsecase,
        ),
        getUserByIdUsecaseProvider.overrideWithValue(
          mockGetUserByIdUsecase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state should be ProfileState()', () {
    final state = container.read(profileViewModelProvider);

    expect(state, const ProfileState());
  });

  test('updateProfile should set status to updated when update succeeds', () async {
    when(
      () => mockUpdateProfileUsecase(any()),
    ).thenAnswer((_) async => const Right(true));

    await container.read(profileViewModelProvider.notifier).updateProfile(
      username: 'Bhusan Shrestha',
      password: '123456',
      profile: null,
    );

    final state = container.read(profileViewModelProvider);

    expect(state.status, ProfileStatus.updated);
    expect(state.errorMessage, null);

    verify(() => mockUpdateProfileUsecase(any())).called(1);
  });

  test('updateProfile should set status to error when usecase returns failure', () async {
    when(
      () => mockUpdateProfileUsecase(any()),
    ).thenAnswer((_) async => const Left(ApiFailure(message: 'Update failed')));

    await container.read(profileViewModelProvider.notifier).updateProfile(
      username: 'Bhusan Shrestha',
      password: '123456',
      profile: null,
    );

    final state = container.read(profileViewModelProvider);

    expect(state.status, ProfileStatus.error);
    expect(state.errorMessage, 'Update failed');

    verify(() => mockUpdateProfileUsecase(any())).called(1);
  });

  test('updateProfile should set status to error when usecase returns false', () async {
    when(
      () => mockUpdateProfileUsecase(any()),
    ).thenAnswer((_) async => const Right(false));

    await container.read(profileViewModelProvider.notifier).updateProfile(
      username: 'Bhusan Shrestha',
      password: '123456',
      profile: null,
    );

    final state = container.read(profileViewModelProvider);

    expect(state.status, ProfileStatus.error);
    expect(state.errorMessage, 'Profile update failed');

    verify(() => mockUpdateProfileUsecase(any())).called(1);
  });

  test('getProfileById should set status to loaded when user is found', () async {
    final user = ProfileEntity(
      username: 'Bhusan Shrestha',
      password: '123456',
      profile: null,
    );

    when(
      () => mockGetUserByIdUsecase(any()),
    ).thenAnswer((_) async => Right(user));

    await container.read(profileViewModelProvider.notifier).getProfileById(
      userId: '1',
    );

    final state = container.read(profileViewModelProvider);

    expect(state.status, ProfileStatus.loaded);
    expect(state.user, user);
    expect(state.errorMessage, null);

    verify(() => mockGetUserByIdUsecase(any())).called(1);
  });

  test('getProfileById should set status to error when usecase fails', () async {
    when(
      () => mockGetUserByIdUsecase(any()),
    ).thenAnswer((_) async => const Left(ApiFailure(message: 'User fetch failed')));

    await container.read(profileViewModelProvider.notifier).getProfileById(
      userId: '1',
    );

    final state = container.read(profileViewModelProvider);

    expect(state.status, ProfileStatus.error);
    expect(state.errorMessage, 'User fetch failed');

    verify(() => mockGetUserByIdUsecase(any())).called(1);
  });

  test('getProfileById should set status to error when user is null', () async {
    when(
      () => mockGetUserByIdUsecase(any()),
    ).thenAnswer((_) async => const Right(null));

    await container.read(profileViewModelProvider.notifier).getProfileById(
      userId: '1',
    );

    final state = container.read(profileViewModelProvider);

    expect(state.status, ProfileStatus.error);
    expect(state.errorMessage, 'User not found');

    verify(() => mockGetUserByIdUsecase(any())).called(1);
  });
}