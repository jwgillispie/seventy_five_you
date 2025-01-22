// lib/features/auth/presentation/bloc/auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';


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
    emit(AuthLoading());
    
    final result = await login(event.email, event.password);
    
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await signup(
      event.email,
      event.password,
      event.username,
    );
    
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthInitial());
  }
}