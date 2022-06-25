import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/auth_gate/bloc/auth_gate_bloc.dart';
import 'package:socnet/di.dart';
import 'package:socnet/features/auth/presentation/pages/auth_page.dart';
import 'package:socnet/features/profile/presentation/my_profile/pages/my_profile_page.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
          create: (context) =>
              sl<AuthGateBloc>()..add(AuthStateUpdateRequested()),
          child: BlocBuilder<AuthGateBloc, AuthGateState>(
              builder: (context, state) {
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

// class _TmpWidget extends StatelessWidget {
//   const _TmpWidget({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       child: const Text("Logout"), 
//       onPressed: () => context.read<AuthGateBloc>().add(LoggedOut()),
//     );
//   }
// }

