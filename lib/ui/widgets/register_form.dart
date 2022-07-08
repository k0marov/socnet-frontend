import 'package:flutter/material.dart';
import 'package:socnet/logic/features/auth/domain/pass_strength_getter.dart';
import 'package:socnet/logic/features/auth/presentation/register_cubit/register_cubit.dart';
import 'package:socnet/ui/widgets/failure_listener.dart';
import 'package:socnet/ui/widgets/submit_button.dart';

import '../../logic/core/field_value.dart';
import 'bloc_field.dart';

double getPasswordProgress(PassStrength strength) {
  switch (strength) {
    case PassStrength.weak:
      return 0;
    case PassStrength.normal:
      return 0.33;
    case PassStrength.strong:
      return 0.66;
    case PassStrength.veryStrong:
      return 1;
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FailureListener<RegisterCubit, RegisterState>(
      getFailure: (state) => state.curFailure,
      child: Column(children: [
        BlocField<RegisterCubit, RegisterState, FieldValue>(
          getValue: (state) => state.curUsername,
          buildField: (value, b) => TextField(
              onChanged: b.usernameChanged,
              decoration: InputDecoration(
                errorText: value.failure?.code,
              )),
        ),
        BlocField<RegisterCubit, RegisterState, FieldValue>(
          getValue: (state) => state.curPass,
          buildField: (value, b) => TextField(
            onChanged: b.passChanged,
            obscureText: true,
            decoration: InputDecoration(
              errorText: value.failure?.code,
            ),
          ),
        ),
        BlocField<RegisterCubit, RegisterState, PassStrength>(
          getValue: (state) => state.curPassStrength,
          buildField: (strength, b) => LinearProgressIndicator(value: getPasswordProgress(strength)),
        ),
        BlocField<RegisterCubit, RegisterState, FieldValue>(
          getValue: (state) => state.curPassRepeat,
          buildField: (value, b) => TextField(
            onChanged: b.passRepeatChanged,
            obscureText: true,
            decoration: InputDecoration(
              errorText: value.failure?.code,
            ),
          ),
        ),
        BlocField<RegisterCubit, RegisterState, bool>(
          getValue: (state) => state.canBeSubmitted,
          buildField: (canBeSubmitted, b) => SubmitButton(
            canBeSubmitted: canBeSubmitted,
            submit: b.registerPressed,
            text: "Register",
          ),
        ),
      ]),
    );
  }
}
