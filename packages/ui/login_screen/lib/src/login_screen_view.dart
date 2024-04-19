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
              const SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Password field, width 300
              const SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<LoginScreenBloc>().add(
                      const OnLoginButtonPressed(
                          email: "aaa", password: "bbb"));
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
                      context.read().add(const OnRegisterPressed());
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
              // Text with link to forgot password screen
              TextButton(
                onPressed: () {
                  context.read().add(const OnForgotPasswordPressed());
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
