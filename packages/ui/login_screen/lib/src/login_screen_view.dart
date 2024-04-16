import 'package:flutter/material.dart';

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
    return Scaffold(
      body: Container(
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
                  Navigator.pushNamed(context, '/main_screen');
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
                child: const Text('Login', style: TextStyle(color: Colors.white),),
              ),
              const SizedBox(height: 20),
              // Text with link to register screen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Don\'t have an account? '),
                  TextButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, '/register_screen');
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
              // Text with link to forgot password screen
              TextButton(
                onPressed: () {
                  // Navigator.pushNamed(context, '/forgot_password_screen');
                },
                child: const Text('Forgot password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
