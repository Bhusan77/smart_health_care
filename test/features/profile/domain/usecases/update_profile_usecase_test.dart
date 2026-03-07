import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:smart_health_care/core/error/failures.dart';
import 'package:smart_health_care/features/profile/domain/entities/profile_entity.dart';
import 'package:smart_health_care/features/profile/domain/repositories/profile_repository.dart';
import 'package:smart_health_care/features/profile/domain/usecases/update_profile_usecase.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}

class FakeProfileEntity extends Fake implements ProfileEntity {}

void main() {
  late UpdateProfileUsecase usecase;
  late MockProfileRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeProfileEntity());
  });

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = UpdateProfileUsecase(profileRepository: mockRepository);
  });

  const params = UpdateProfileUsecaseParams(
    username: "aayush",
    password: "123456",
    profile: null,
  );

  final entity = ProfileEntity(
    username: "aayush",
    password: "123456",
    profile: null,
  );

  test("should update profile successfully", () async {
    when(() => mockRepository.updateProfile(any()))
        .thenAnswer((_) async => const Right(true));

    final result = await usecase(params);

    expect(result, const Right(true));
    verify(() => mockRepository.updateProfile(any())).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test("should return Failure when update fails", () async {
    when(() => mockRepository.updateProfile(any()))
        .thenAnswer((_) async => const Left(ApiFailure(message: "Update failed")));

    final result = await usecase(params);

    expect(result, const Left(ApiFailure(message: "Update failed")));
    verify(() => mockRepository.updateProfile(any())).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test("should pass correct ProfileEntity to repository", () async {
    when(() => mockRepository.updateProfile(any()))
        .thenAnswer((_) async => const Right(true));

    await usecase(params);

    verify(() => mockRepository.updateProfile(entity)).called(1);
  });
}