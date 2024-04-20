import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_screen/src/bloc/bloc.dart';
import 'package:login_screen/src/bloc/state.dart';
import 'package:login_screen/src/login_loading.dart';
import 'package:login_screen/src/login_screen_view.dart';

class LoginScreenLayout extends StatelessWidget {
  const LoginScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LoginScreenBloc(),
        child: const _LoginScreenLayout());
  }
}

class _LoginScreenLayout extends StatelessWidget {
  const _LoginScreenLayout();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginScreenBloc, LoginScreenState>(
      builder: (context, state) {
        if (state.state == LoginState.loading) {
          return const Scaffold(
            body: LoginLoading(),
          );
        } else {
          return const Scaffold(
            body: LoginScreen(),
          );
        }
      },
    );
  }
}
