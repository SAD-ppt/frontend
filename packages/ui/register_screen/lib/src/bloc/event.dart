import 'package:equatable/equatable.dart';

class RegisterScreenEvent extends Equatable {
  const RegisterScreenEvent();

  @override
  List<Object> get props => [];
}

class OnRegisterButtonPressed extends RegisterScreenEvent {
  final String email;
  final String password;
  final String confirmPassword;

  const OnRegisterButtonPressed({required this.email, required this.password, required this.confirmPassword});

  @override
  List<Object> get props => [email, password, confirmPassword];
}