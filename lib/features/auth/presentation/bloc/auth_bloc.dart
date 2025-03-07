// lib/features/auth/presentation/bloc/auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seventy_five_hard/features/auth/domain/usecases/login.dart';
import 'package:seventy_five_hard/features/auth/domain/usecases/signup.dart';
import 'package:seventy_five_hard/features/auth/presentation/bloc/auth_event.dart';
import 'package:seventy_five_hard/features/auth/presentation/bloc/auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Signup signup;

  AuthBloc({
    required this.login,
    required this.signup,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    print("AuthBloc: Login requested for email: ${event.email}");
    emit(AuthLoading());
    
    final result = await login(event.email, event.password);
    
    result.fold(
      (failure) {
        print("AuthBloc: Login failed with error: ${failure.message}");
        emit(AuthError(message: failure.message));
      },
      (user) {
        print("AuthBloc: Login successful for user: ${user.displayName}");
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    print("AuthBloc: Signup requested for email: ${event.email}, username: ${event.username}");
    emit(AuthLoading());
    
    final result = await signup(
      event.email,
      event.password,
      event.username,
    );
    
    result.fold(
      (failure) {
        print("AuthBloc: Signup failed with error: ${failure.message}");
        emit(AuthError(message: failure.message));
      },
      (user) {
        print("AuthBloc: Signup successful for user: ${user.displayName}");
        emit(AuthAuthenticated(user));
      },
    );
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    print("AuthBloc: Logout requested");
    emit(AuthInitial());
  }
}