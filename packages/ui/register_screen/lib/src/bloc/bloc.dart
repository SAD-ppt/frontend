import 'package:bloc/bloc.dart';
import 'package:register_screen/src/bloc/event.dart';
import 'package:register_screen/src/bloc/state.dart';

class RegisterScreenBloc
    extends Bloc<RegisterScreenEvent, RegisterScreenState> {
  RegisterScreenBloc() : super(const RegisterScreenState()) {
    on<OnRegisterButtonPressed>(_onRegisterButtonPressed);
  }

  void _onRegisterButtonPressed(
      OnRegisterButtonPressed event, Emitter<RegisterScreenState> emit) async {
    emit(const RegisterScreenState(state: RegisterState.loading));
    // Check if any of the fields are empty
    if (event.email.isEmpty ||
        event.password.isEmpty ||
        event.confirmPassword.isEmpty) {
      emit(const RegisterScreenState(state: RegisterState.emptyFields));
      return;
    }
    // Check if the password and confirm password match
    if (event.password != event.confirmPassword) {
      emit(const RegisterScreenState(state: RegisterState.confirmNotMatch));
      return;
    }
    // Call the register service
    // If the register is successful, emit(RegisterState.success)
    // wait 2 seconds to simulate a network request
    await Future.delayed(const Duration(seconds: 2)).then((value) {
      emit(const RegisterScreenState(state: RegisterState.failure));
    });
    // If the register fails, emit(RegisterState.failure)
  }
}
