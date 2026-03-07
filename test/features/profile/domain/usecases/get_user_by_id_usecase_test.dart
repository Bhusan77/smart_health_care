import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_health_care/core/error/failures.dart';
import 'package:smart_health_care/features/profile/domain/entities/profile_entity.dart';
import 'package:smart_health_care/features/profile/domain/repositories/profile_repository.dart';
import 'package:smart_health_care/features/profile/domain/usecases/get_user_by_id_usecase.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}

void main() {
  late GetUserByIdUsecase usecase;
  late MockProfileRepository mockRepository;

  setUp(() {
    mockRepository = MockProfileRepository();
    usecase = GetUserByIdUsecase(profileRepository: mockRepository);
  });

  const params = GetUserByIdUsecaseParams(userId: "123");

  final profileEntity = ProfileEntity(
    username: "Aayush",
    password: "123456",
    profile: File("test/sample.jpg"),
  );

  test("should return ProfileEntity when getUserById is successful", () async {
    when(() => mockRepository.getUserById(any()))
        .thenAnswer((_) async => Right(profileEntity));

    final result = await usecase(params);

    expect(result, Right(profileEntity));
    verify(() => mockRepository.getUserById("123")).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test("should return ApiFailure when getUserById fails", () async {
    when(() => mockRepository.getUserById(any())).thenAnswer(
      (_) async => const Left(ApiFailure(message: "User not found")),
    );

    final result = await usecase(params);

    expect(result, const Left(ApiFailure(message: "User not found")));
    verify(() => mockRepository.getUserById("123")).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}