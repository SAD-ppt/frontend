import 'package:flutter/material.dart';

class RegisterLoading extends StatelessWidget {
  const RegisterLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return
        // Add background picture
        Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/login_background.png',
                    package: 'login_screen'),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(),
            ));
  }
}
