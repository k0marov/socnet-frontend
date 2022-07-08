import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/features/auth/presentation/login_cubit/login_cubit.dart';
import 'package:socnet/ui/widgets/bloc_field.dart';
import 'package:socnet/ui/widgets/custom_text_field.dart';
import 'package:socnet/ui/widgets/failure_listener.dart';
import 'package:socnet/ui/widgets/submit_button.dart';

import '../../logic/core/field_value.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  LoginCubit _loginCubit(BuildContext context) => context.read<LoginCubit>();

  @override
  Widget build(BuildContext context) {
    return FailureListener<LoginCubit, LoginState>(
      getFailure: (state) => state.failure,
      child: Column(children: [
        BlocField<LoginCubit, LoginState, FieldValue, Function(String)>(
          getValue: (state) => state.curUsername,
          getMethod: (b) => b.usernameChanged,
          buildField: (value, onChanged) => CustomTextField(value: value, onChanged: onChanged),
        ),
        BlocField<LoginCubit, LoginState, FieldValue, Function(String)>(
          getValue: (state) => state.curPassword,
          getMethod: (b) => b.passwordChanged,
          buildField: (value, onChanged) => CustomTextField(value: value, onChanged: onChanged),
        ),
        BlocField<LoginCubit, LoginState, bool, Function()>(
          getValue: (state) => state.canBeSubmitted,
          getMethod: (b) => b.loginPressed,
          buildField: (canBeSubmitted, submit) => SubmitButton(
            canBeSubmitted: canBeSubmitted,
            submit: submit,
          ),
        ),
      ]),
    );
  }
}
