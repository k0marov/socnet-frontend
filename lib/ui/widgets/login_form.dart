import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/features/auth/presentation/login_cubit/login_cubit.dart';
import 'package:socnet/ui/widgets/bloc_field.dart';
import 'package:socnet/ui/widgets/failure_listener.dart';
import 'package:socnet/ui/widgets/submit_button.dart';
import 'package:socnet/ui/widgets/z_text_field.dart';

import '../../logic/core/field_value.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  LoginCubit _loginCubit(BuildContext context) => context.read<LoginCubit>();

  @override
  Widget build(BuildContext context) {
    return FailureListener<LoginCubit, LoginState>(
      getFailure: (state) => state.failure,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(children: [
          SizedBox(height: 300),
          BlocField<LoginCubit, LoginState, FieldValue>(
            getValue: (state) => state.username,
            buildField: (value, b) => ZTextField(
              onChanged: b.usernameChanged,
              value: value,
              label: "Username",
            ),
          ),
          SizedBox(height: 15),
          BlocField<LoginCubit, LoginState, FieldValue>(
            getValue: (state) => state.password,
            buildField: (value, b) => ZTextField(
              onChanged: b.passwordChanged,
              value: value,
              label: "Password",
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
      ),
    );
  }
}
