import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/di.dart';
import '../../logic/features/auth/presentation/auth_gate/bloc/auth_gate_bloc.dart';
import 'auth_page.dart';
import 'my_profile_page.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
          value: sl<AuthGateBloc>()..add(AuthStateUpdateRequested()),
          child: BlocBuilder<AuthGateBloc, AuthGateState>(builder: (context, state) {
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
