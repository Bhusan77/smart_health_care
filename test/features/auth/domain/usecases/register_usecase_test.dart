import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_health_care/core/error/failures.dart';
import 'package:smart_health_care/features/auth/domain/entities/auth_entity.dart';
import 'package:smart_health_care/features/auth/domain/repositories/auth_repository.dart';
import 'package:smart_health_care/features/auth/domain/usecases/register_usecase.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class FakeAuthEntity extends Fake implements AuthEntity {}

void main() {
  late RegisterUsecase registerUsecase;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(FakeAuthEntity());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    registerUsecase = RegisterUsecase(authRepository: mockAuthRepository);
  });

  const registerParams = RegisterParams(
    username: "Bhusan Shrestha",
    email: "bhusan@gmail.com",
    password: "123456",
  );

  const authEntity = AuthEntity(
    username: "Bhusan Shrestha",
    email: "bhusan@gmail.com",
    password: "123456",
  );

  test("should return true when register is successful", () async {
    when(() => mockAuthRepository.register(any()))
        .thenAnswer((_) async => const Right(true));

    final result = await registerUsecase(registerParams);

    expect(result, const Right(true));
    verify(() => mockAuthRepository.register(authEntity)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test("should return Failure when register fails", () async {
    when(() => mockAuthRepository.register(any())).thenAnswer(
      (_) async => const Left(ApiFailure(message: "Register failed")),
    );

    final result = await registerUsecase(registerParams);

    expect(result, const Left(ApiFailure(message: "Register failed")));
    verify(() => mockAuthRepository.register(authEntity)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}