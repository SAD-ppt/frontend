import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:register_screen/register_screen.dart';
import 'package:register_screen/src/bloc/bloc.dart';
import 'package:register_screen/src/bloc/state.dart';
import 'package:register_screen/src/register_loading.dart';
import 'package:register_screen/src/register_screen_view.dart';

class RegisterScreenLayout extends StatelessWidget {
  const RegisterScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => RegisterScreenBloc(),
        child: const _RegisterScreenLayout());
  }
}

class _RegisterScreenLayout extends StatelessWidget {
  const _RegisterScreenLayout();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterScreenBloc, RegisterScreenState>(
        builder: (context, state) {
      if (state.state == RegisterState.loading) {
        return const Scaffold(
          body: RegisterLoading(key: Key('register_loading')),
        );
      } else {
        return const Scaffold(
          body: RegisterScreen(key: Key('register_screen')),
        );
      }
    });
  }
}
