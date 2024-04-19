import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/src/bloc/bloc.dart';
import 'package:login_screen/src/bloc/event.dart';
import 'package:login_screen/src/bloc/state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _LoginScreenView();
  }
}

class _LoginScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return BlocBuilder<LoginScreenBloc, LoginScreenState>(
        builder: (context, state) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/login_background.png',
                package: 'login_screen'),
            fit: BoxFit.cover,
            opacity: 0.3,
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
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // get the email and password from the text fields
                  String getEmailFromField = emailController.text;
                  String getPasswordFromField = passwordController.text;
                  context.read<LoginScreenBloc>().add(
                      OnLoginButtonPressed(
                          email: getEmailFromField, password: getPasswordFromField));
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
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              // If text field is empty, show a notification overlay alert
              if (state.state == LoginState.emptyFields)
                const Text(
                  'Email and password fields cannot be empty.',
                  style: TextStyle(color: Colors.red),
                ),
              // Add a notification overlay alert if login fails
              if (state.state == LoginState.failure)
                const Text(
                  'Login failed, please try again.', // will be replaced with the message from the server later
                  style: TextStyle(color: Colors.red),
                ),
              // Text with link to register screen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Don\'t have an account? '),
                  TextButton(
                    onPressed: () {
                      context.read<LoginScreenBloc>().add(const OnRegisterPressed());
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
              // Text with link to forgot password screen
              TextButton(
                onPressed: () {
                  context.read<LoginScreenBloc>().add(const OnForgotPasswordPressed());
                },
                child: const Text('Forgot password?'),
              ),
            ],
          ),
        ),
        // Add a notification overlay alert if login fails  
      );
    });
  }
}
