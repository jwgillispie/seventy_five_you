//lib/features/auth/presentation/bloc/auth_state.dart


import 'package:equatable/equatable.dart';
import 'package:seventy_five_hard/features/auth/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}