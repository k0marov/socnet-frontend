import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/features/auth/presentation/login_cubit/login_cubit.dart';
import 'package:socnet/ui/widgets/bloc_field.dart';
import 'package:socnet/ui/widgets/failure_listener.dart';
import 'package:socnet/ui/widgets/submit_button.dart';

import '../../logic/core/field_value.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  LoginCubit _loginCubit(BuildContext context) => context.read<LoginCubit>();

  @override
  Widget build(BuildContext context) {
    return FailureListener<LoginCubit, LoginState>(
      getFailure: (state) => state.curFailure,
      child: Column(children: [
        BlocField<LoginCubit, LoginState, FieldValue>(
          getValue: (state) => state.curUsername,
          buildField: (value, b) => TextField(
              onChanged: b.usernameChanged,
              decoration: InputDecoration(
                errorText: value.failure?.code,
              )),
        ),
        BlocField<LoginCubit, LoginState, FieldValue>(
          getValue: (state) => state.curPassword,
          buildField: (value, b) => TextField(
            onChanged: b.passwordChanged,
            obscureText: true,
            decoration: InputDecoration(
              errorText: value.failure?.code,
            ),
          ),
        ),
        BlocField<LoginCubit, LoginState, bool>(
          getValue: (state) => state.canBeSubmitted,
          buildField: (canBeSubmitted, b) => SubmitButton(
            canBeSubmitted: canBeSubmitted,
            submit: b.loginPressed,
            text: "Login",
          ),
        ),
      ]),
    );
  }
}
