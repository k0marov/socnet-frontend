import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/ui/widgets/failure_listener.dart';

import '../../logic/di.dart';
import '../../logic/features/auth/presentation/auth_gate_cubit/auth_gate_cubit.dart';
import 'auth_page.dart';
import 'my_profile_page.dart';

class AuthGatePage extends StatelessWidget {
  const AuthGatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthGateCubit>()..refreshState(),
      child: FailureListener<AuthGateCubit, AuthState>(
        getFailure: (state) => state.failure,
        child: BlocBuilder<AuthGateCubit, AuthState>(
          builder: (context, state) => state.isAuthenticated ? MyProfilePage() : AuthPage(),
        ),
      ),
    );
  }
}
