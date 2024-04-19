import 'package:equatable/equatable.dart';

enum LoginState {
  initial,
  loading,
  success,
  failure,
  emptyFields,
  forgotPassword,
  register
}

class LoginScreenState extends Equatable {
  final LoginState state;

  const LoginScreenState({this.state = LoginState.initial});

  @override
  List<Object> get props => [state];
}
