import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/features/auth/presentation/login_cubit/login_cubit.dart';
import 'package:socnet/logic/features/auth/presentation/register_cubit/register_cubit.dart';
import 'package:socnet/ui/widgets/background.dart';
import 'package:socnet/ui/widgets/login_form.dart';
import 'package:socnet/ui/widgets/logo_widget.dart';
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
            child: Text("Don't have an account?"),
          ),
        ]
      : [
          BlocProvider<RegisterCubit>(
            create: (_) => sl(),
            child: RegisterForm(),
          ),
          TextButton(
            onPressed: () => setState(() => _state = _AuthState.Login),
            child: Text("Already have an account?"),
          ),
        ];

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: ListView(children: [
            SizedBox(height: 150),
            SizedBox(
              width: 150,
              height: 150,
              child: LogoWidget(),
            ),
            SizedBox(height: 30),
            ..._getFormBody(),
          ]),
        ),
      ),
    );
  }
}
