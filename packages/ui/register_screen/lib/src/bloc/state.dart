import 'package:equatable/equatable.dart';

enum RegisterState {
  initial,
  loading,
  success,
  failure,
  confirmNotMatch,
  emptyFields,
}

class RegisterScreenState extends Equatable {
  final RegisterState state;

  const RegisterScreenState({
    this.state = RegisterState.initial,
  });

  @override
  List<Object> get props => [state];
}
