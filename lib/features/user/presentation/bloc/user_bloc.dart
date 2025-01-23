//lib/features/user/presentation/bloc/user_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/features/user/presentation/bloc/user_event.dart';
import 'dart:convert';

import 'package:seventy_five_hard/features/user/presentation/bloc/user_state.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
  final _baseUrl = 'http://localhost:8000';
  
  UserBloc() : super(UserInitial()) {
    on<FetchUserName>(_onFetchUserName);
    on<UpdateUserName>(_onUpdateUserName);
  }

  Future<void> _onFetchUserName(
    FetchUserName event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/user/${event.userId}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        emit(UserLoaded(data['display_name'] ?? 'Warrior'));
      } else {
        emit(UserError('Failed to fetch user data'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUserName(
    UpdateUserName event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/user/${event.userId}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'display_name': event.newName,
        }),
      );

      if (response.statusCode == 200) {
        emit(UserLoaded(event.newName));
      } else {
        emit(UserError('Failed to update username'));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}