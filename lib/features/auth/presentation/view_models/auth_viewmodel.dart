import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_health_care/features/auth/domain/usecases/login_usecase.dart';
import 'package:smart_health_care/features/auth/domain/usecases/register_usecase.dart';
import 'package:smart_health_care/features/auth/presentation/state/auth_state.dart';

final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    return const AuthState();
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      errorMessage: null,
    );

    final result = await _registerUsecase(
      RegisterParams(
        username: username,
        email: email,
        password: password,
      ),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (success) {
        state = state.copyWith(
          status: AuthStatus.registered,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      errorMessage: null,
    );

    final result = await _loginUsecase(
      LoginParams(email: email, password: password),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (user) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      errorMessage: null,
    );

    try {
      // TODO: connect real backend/usecase here later
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(
        status: AuthStatus.passwordChanged,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Failed to change password',
      );
    }
  }

  void resetState() {
    state = const AuthState();
  }
}