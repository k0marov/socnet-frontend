import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/di.dart';
import 'package:socnet/features/auth/presentation/widgets/login_form.dart';
import 'package:socnet/features/auth/presentation/widgets/register_form.dart';

import '../bloc/auth_page_bloc.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthPageBlocCreator>().create(context.read()),
      child: const _AuthPageInternal(),
    );
  }
}

class _AuthPageInternal extends StatelessWidget {
  const _AuthPageInternal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Authentication"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: BlocBuilder(
                bloc: context.read<AuthPageBloc>(),
                builder: (context, state) {
                  if (state is AuthPageLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AuthPageLogin) {
                    final failure = state is AuthPageLoginFailure ? state.failure : null;
                    return Column(children: [
                      LoginForm(failure: failure),
                      TextButton(
                        child: const Text("Switch to Registration"),
                        onPressed: () => context.read<AuthPageBloc>().add(SwitchedToRegistration()),
                      )
                    ]);
                  } else if (state is AuthPageRegistration) {
                    final failure = state is AuthPageRegistrationFailure ? state.failure : null;
                    return Column(children: [
                      RegisterForm(failure: failure),
                      TextButton(
                        child: const Text("Switch to Login"),
                        onPressed: () => context.read<AuthPageBloc>().add(SwitchedToLogin()),
                      )
                    ]);
                  } else {
                    return Container();
                  }
                })));
  }
}
