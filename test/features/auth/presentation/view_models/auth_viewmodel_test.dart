import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_health_care/core/error/failures.dart';
import 'package:smart_health_care/features/auth/domain/entities/auth_entity.dart';

import 'package:smart_health_care/features/auth/domain/usecases/login_usecase.dart';
import 'package:smart_health_care/features/auth/domain/usecases/register_usecase.dart';
import 'package:smart_health_care/features/auth/presentation/state/auth_state.dart';
import 'package:smart_health_care/features/auth/presentation/view_models/auth_viewmodel.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

void main() {
  late ProviderContainer container;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;

  setUpAll(() {
    registerFallbackValue(
      RegisterParams(
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
      ),
    );

    registerFallbackValue(
      LoginParams(
        email: 'test@example.com',
        password: 'password123',
      ),
    );
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();

    container = ProviderContainer(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthViewModel', () {
    test('initial state should be initial', () {
      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.initial);
      expect(state.user, isNull);
      expect(state.errorMessage, isNull);
    });

    test('register success -> registered state', () async {
      when(() => mockRegisterUsecase(any()))
          .thenAnswer((_) async => const Right(true));

      await container.read(authViewModelProvider.notifier).register(
            username: 'testuser',
            email: 'test@example.com',
            password: 'password123',
          );

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.registered);
      expect(state.errorMessage, isNull);

      verify(() => mockRegisterUsecase(any())).called(1);
    });

    test('register failure -> error state', () async {
      when(() => mockRegisterUsecase(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Register failed')),
      );

      await container.read(authViewModelProvider.notifier).register(
            username: 'testuser',
            email: 'test@example.com',
            password: 'password123',
          );

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Register failed');

      verify(() => mockRegisterUsecase(any())).called(1);
    });

    test('login success -> authenticated state', () async {
      const user = AuthEntity(
        authId: '1',
        username: 'testuser',
        email: 'test@example.com',
        password: null,
      );

      when(() => mockLoginUsecase(any()))
          .thenAnswer((_) async => const Right(user));

      await container.read(authViewModelProvider.notifier).login(
            email: 'test@example.com',
            password: 'password123',
          );

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.authenticated);
      expect(state.user, user);
      expect(state.errorMessage, isNull);

      verify(() => mockLoginUsecase(any())).called(1);
    });

    test('login failure -> error state', () async {
      when(() => mockLoginUsecase(any())).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Invalid credentials')),
      );

      await container.read(authViewModelProvider.notifier).login(
            email: 'test@example.com',
            password: 'wrongpassword',
          );

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Invalid credentials');
      expect(state.user, isNull);

      verify(() => mockLoginUsecase(any())).called(1);
    });

    test('changePassword success -> passwordChanged state', () async {
      await container.read(authViewModelProvider.notifier).changePassword(
            oldPassword: 'old123456',
            newPassword: 'new123456',
          );

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.passwordChanged);
      expect(state.errorMessage, isNull);
    });

    test('resetState -> back to initial', () async {
      const user = AuthEntity(
        authId: '1',
        username: 'testuser',
        email: 'test@example.com',
        password: null,
      );

      when(() => mockLoginUsecase(any()))
          .thenAnswer((_) async => const Right(user));

      await container.read(authViewModelProvider.notifier).login(
            email: 'test@example.com',
            password: 'password123',
          );

      container.read(authViewModelProvider.notifier).resetState();

      final state = container.read(authViewModelProvider);

      expect(state.status, AuthStatus.initial);
      expect(state.user, isNull);
      expect(state.errorMessage, isNull);
    });
  });
}