import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/di.dart';
import '../../logic/features/auth/presentation/auth_gate/auth_gate_cubit.dart';
import 'auth_page.dart';
import 'my_profile_page.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
          create: (_) => sl<AuthGateCubit>()..add(AuthStateUpdateRequested()),
          child: BlocBuilder<AuthGateCubit, AuthState>(builder: (context, state) {
            print(state);
            if (state is AuthGateInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthGateUnauthenticated) {
              return const AuthPage();
            } else {
              // authenticated
              return const MyProfilePage();
            }
          })),
    );
  }
}
