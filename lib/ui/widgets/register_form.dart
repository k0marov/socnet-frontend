import 'package:flutter/material.dart';
import 'package:socnet/logic/features/auth/presentation/register_cubit/register_cubit.dart';
import 'package:socnet/ui/widgets/failure_listener.dart';
import 'package:socnet/ui/widgets/submit_button.dart';

import '../../logic/core/field_value.dart';
import 'bloc_field.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FailureListener<RegisterCubit, RegisterState>(
      getFailure: (state) => state.curFailure,
      child: Column(children: [
        BlocField<RegisterCubit, RegisterState, FieldValue, Function(String)>(
          getValue: (state) => state.curUsername,
          getMethod: (b) => b.usernameChanged,
          buildField: (value, onChanged) => TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                errorText: value.failure?.code,
              )),
        ),
        BlocField<RegisterCubit, RegisterState, FieldValue, Function(String)>(
          getValue: (state) => state.curPass,
          getMethod: (b) => b.passChanged,
          buildField: (value, onChanged) => TextField(
            onChanged: onChanged,
            obscureText: true,
            decoration: InputDecoration(
              errorText: value.failure?.code,
            ),
          ),
        ),
        BlocField<RegisterCubit, RegisterState, FieldValue, Function(String)>(
          getValue: (state) => state.curPassRepeat,
          getMethod: (b) => b.passRepeatChanged,
          buildField: (value, onChanged) => TextField(
            onChanged: onChanged,
            obscureText: true,
            decoration: InputDecoration(
              errorText: value.failure?.code,
            ),
          ),
        ),
        BlocField<RegisterCubit, RegisterState, bool, Function()>(
          getValue: (state) => state.canBeSubmitted,
          getMethod: (b) => b.registerPressed,
          buildField: (canBeSubmitted, submit) => SubmitButton(
            canBeSubmitted: canBeSubmitted,
            submit: submit,
            text: "Register",
          ),
        ),
      ]),
    );
  }
}
