import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/features/auth/presentation/login_cubit/login_cubit.dart';
import 'package:socnet/ui/widgets/login_form.dart';
import 'package:socnet/ui/widgets/register_form.dart';

import '../../logic/di.dart';

enum _AuthState {
  Login,
  Registration,
}

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  _AuthState _state = _AuthState.Login;

  List<Widget> _getFormBody() => _state == _AuthState.Login
      ? [
          BlocProvider<LoginCubit>(
            create: (_) => sl(),
            child: LoginForm(),
          ),
          TextButton(
            onPressed: () => setState(() => _state = _AuthState.Registration),
            child: Text("Already have an account?"),
          ),
        ]
      : [
          BlocProvider<LoginCubit>(
            create: (_) => sl(),
            child: RegisterForm(),
          ),
          TextButton(
            onPressed: () => setState(() => _state = _AuthState.Login),
            child: Text("Don't have an account?"),
          ),
        ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        ..._getFormBody(),
      ]),
    );
  }
}
