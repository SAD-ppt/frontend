import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:register_screen/src/bloc/bloc.dart';
import 'package:register_screen/src/bloc/event.dart';
import 'package:register_screen/src/bloc/state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _RegisterScreenView();
  }
}

class _RegisterScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();
    return BlocBuilder<RegisterScreenBloc, RegisterScreenState>(
        builder: (context, state) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/register_background.png',
                package: 'register_screen'),
            fit: BoxFit.cover,
            opacity: 0.4,
          ),
        ),
        child: Center(
          child: Column(
            // load background image from assets
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'AnkiClone',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              // Username field, width 300
              SizedBox(
                width: 300,
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Password field, width 300
              SizedBox(
                width: 300,
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: TextField(
                  obscureText: true,
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                  ),
                ),
              ),
              // If any field is empty, show error message
              if (state.state == RegisterState.emptyFields)
                const Text(
                  'Please fill in all fields',
                  style: TextStyle(color: Colors.red),
                ),
              // If password and confirm password do not match, show error message
              if (state.state == RegisterState.confirmNotMatch)
                const Text(
                  'Passwords do not match',
                  style: TextStyle(color: Colors.red),
                ),
              // If register fails, show error message
              if (state.state == RegisterState.failure)
                const Text(
                  'Register failed, please try again',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String getEmailFromField = emailController.text;
                  String getPasswordFromField = passwordController.text;
                  context.read<RegisterScreenBloc>().add(
                      OnRegisterButtonPressed(
                          email: getEmailFromField,
                          password: getPasswordFromField,
                          confirmPassword: confirmPasswordController.text));
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromWidth(300),
                  // get primary color from theme
                  backgroundColor: Theme.of(context).primaryColor,
                  // rectangle border
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
