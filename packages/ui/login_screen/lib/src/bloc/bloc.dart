import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:login_screen/src/bloc/event.dart';
import 'package:login_screen/src/bloc/state.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  LoginScreenBloc() : super(const LoginScreenState()) {
    on<OnLoginButtonPressed>(_onLoginButtonPressed);
    on<OnRegisterPressed>(_onRegisterPressed);
    on<OnForgotPasswordPressed>(_onForgotPasswordPressed);
  }

  FutureOr<void> _onLoginButtonPressed(
      OnLoginButtonPressed event, Emitter<LoginScreenState> emit) async {
    emit(const LoginScreenState(state: LoginState.loading));
    // Validate the email and password fields
    if (event.email.isEmpty || event.password.isEmpty) {
      emit(const LoginScreenState(state: LoginState.emptyFields));
      return;
    }
    // Call the login service
    // If the login is successful, emit(LoginState.success)
    // wait 2 seconds to simulate a network request
    await Future.delayed(const Duration(seconds: 2));
    // emit(const LoginScreenState(state: LoginState.success));
    // If the login fails, emit(LoginState.failure)
    emit(const LoginScreenState(state: LoginState.failure));
  }

  FutureOr<void> _onRegisterPressed(
      OnRegisterPressed event, Emitter<LoginScreenState> emit) {
    // Navigate to the register screen
    emit(const LoginScreenState(state: LoginState.register));
  }

  FutureOr<void> _onForgotPasswordPressed(
      OnForgotPasswordPressed event, Emitter<LoginScreenState> emit) {
    // Navigate to the forgot password screen
    emit(const LoginScreenState(state: LoginState.forgotPassword));
  }
}