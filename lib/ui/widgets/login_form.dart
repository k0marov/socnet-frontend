import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/core/error/form_failures.dart';
import 'package:socnet/logic/features/auth/presentation/login_cubit/login_cubit.dart';
import 'package:socnet/ui/widgets/bloc_field.dart';
import 'package:socnet/ui/widgets/failure_listener.dart';
import 'package:socnet/ui/widgets/submit_button.dart';

import '../theme.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  LoginCubit _loginCubit(BuildContext context) => context.read<LoginCubit>();

  @override
  Widget build(BuildContext context) {
    return FailureListener<LoginCubit, LoginState>(
      getFailure: (state) => state.failure,
      child: Column(children: [
        BlocField<LoginCubit, LoginState, FormFailure?>(
          getValue: (state) => state.username.failure,
          buildField: (value, b) => TextField(
            onChanged: b.usernameChanged,
            decoration: inputDecoration.copyWith(label: Text("Username"), errorText: value?.code),
          ),
        ),
        SizedBox(height: 15),
        BlocField<LoginCubit, LoginState, FormFailure?>(
          getValue: (state) => state.password.failure,
          buildField: (value, b) => TextField(
            onChanged: b.passwordChanged,
            decoration: inputDecoration.copyWith(
              errorText: value?.code,
              label: Text("Password"),
            ),
            obscureText: true,
          ),
        ),
        SizedBox(height: 20),
        BlocField<LoginCubit, LoginState, bool>(
          getValue: (state) => state.canBeSubmitted,
          buildField: (canBeSubmitted, b) => SubmitButton(
            canBeSubmitted: canBeSubmitted,
            submit: b.loginPressed,
            text: "LOGIN",
          ),
        ),
      ]),
    );
  }
}
