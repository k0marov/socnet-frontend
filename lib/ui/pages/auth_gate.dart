import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/features/auth/presentation/auth_gate_cubit/auth_gate_cubit.dart';
import 'package:socnet/ui/pages/auth_page.dart';
import 'package:socnet/ui/pages/my_profile_page.dart';
import 'package:socnet/ui/pages/splash_screen.dart';

import '../../logic/di.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthGateCubit>()..renewStream(),
      child: BlocBuilder<AuthGateCubit, AuthState>(
        builder: (ctx, state) {
          switch (state) {
            case AuthState.loading:
              return const SplashScreen();
            case AuthState.authenticated:
              return const MyProfilePage();
            case AuthState.unauthenticated:
              return const AuthPage();
            case AuthState.failure:
              return Scaffold(
                body: Column(
                  children: [
                    const Text("Some error happened."),
                    ElevatedButton(
                      onPressed: () => context.read<AuthGateCubit>().renewStream(),
                      child: const Text("Try again"),
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
