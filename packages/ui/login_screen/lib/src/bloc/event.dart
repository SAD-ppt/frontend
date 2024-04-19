import 'package:equatable/equatable.dart';

class LoginScreenEvent extends Equatable {
  const LoginScreenEvent();

  @override
  List<Object> get props => [];
}

class OnLoginButtonPressed extends LoginScreenEvent {
  final String email;
  final String password;

  const OnLoginButtonPressed({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class OnRegisterPressed extends LoginScreenEvent {
  const OnRegisterPressed();

  @override
  List<Object> get props => [];
}

class OnForgotPasswordPressed extends LoginScreenEvent {
  const OnForgotPasswordPressed();

  @override
  List<Object> get props => [];
}
