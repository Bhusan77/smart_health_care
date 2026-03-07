import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_health_care/core/error/failures.dart';
import 'package:smart_health_care/features/auth/domain/entities/auth_entity.dart';
import 'package:smart_health_care/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_health_care/features/auth/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUsecase loginUsecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUsecase = LoginUsecase(authRepository: mockAuthRepository);
  });

  const loginParams = LoginParams(
    email: "bhusan@gmail.com",
    password: "123456",
  );

  const authEntity = AuthEntity(
    authId: "1",
    username: "Bhusan Shrestha",
    email: "bhusan@gmail.com",
    password: "123456",
  );

  test("should return AuthEntity when login is successful", () async {
    // arrange
    when(() => mockAuthRepository.login(any(), any()))
        .thenAnswer((_) async => const Right(authEntity));

    // act
    final result = await loginUsecase(loginParams);

    // assert
    expect(result, const Right(authEntity));
    verify(() => mockAuthRepository.login("bhusan@gmail.com", "123456")).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test("should return Failure when login fails", () async {
    // arrange
    when(() => mockAuthRepository.login(any(), any()))
        .thenAnswer((_) async => const Left(ApiFailure(message: "Login failed")));

    // act
    final result = await loginUsecase(loginParams);

    // assert
    expect(result, const Left(ApiFailure(message: "Login failed")));
    verify(() => mockAuthRepository.login("bhusan@gmail.com", "123456")).called(1);
  });
}