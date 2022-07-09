import 'package:flutter/material.dart';
import 'package:socnet/logic/features/auth/domain/pass_strength_getter.dart';
import 'package:socnet/logic/features/auth/presentation/register_cubit/register_cubit.dart';
import 'package:socnet/ui/widgets/failure_listener.dart';
import 'package:socnet/ui/widgets/submit_button.dart';
import 'package:socnet/ui/widgets/z_text_field.dart';

import '../../logic/core/field_value.dart';
import 'bloc_field.dart';

double getPasswordProgress(PassStrength strength) {
  switch (strength) {
    case PassStrength.none:
      return 0;
    case PassStrength.weak:
      return 0.25;
    case PassStrength.normal:
      return 0.5;
    case PassStrength.strong:
      return 0.75;
    case PassStrength.veryStrong:
      return 1;
  }
}

Color getStrengthColor(PassStrength strength) {
  switch (strength) {
    case PassStrength.none:
      return Colors.grey;
    case PassStrength.weak:
      return Colors.red;
    case PassStrength.normal:
      return Colors.orange;
    case PassStrength.strong:
      return Colors.lightGreen;
    case PassStrength.veryStrong:
      return Colors.green;
  }
}

Color getStrengthBackground(PassStrength strength) {
  switch (strength) {
    case PassStrength.none:
      return Colors.grey.shade200;
    case PassStrength.weak:
      return Colors.red.shade200;
    case PassStrength.normal:
      return Colors.orange.shade200;
    case PassStrength.strong:
      return Colors.lightGreen.shade200;
    case PassStrength.veryStrong:
      return Colors.green.shade200;
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FailureListener<RegisterCubit, RegisterState>(
      getFailure: (state) => state.failure,
      child: Column(children: [
        BlocField<RegisterCubit, RegisterState, FieldValue>(
          getValue: (state) => state.username,
          buildField: (value, b) => ZTextField(
            onChanged: b.usernameChanged,
            value: value,
            label: "Username",
          ),
        ),
        SizedBox(height: 15),
        BlocField<RegisterCubit, RegisterState, FieldValue>(
          getValue: (state) => state.pass,
          buildField: (value, b) => ZTextField(
            onChanged: b.passChanged,
            obscureText: true,
            value: value,
            label: "Password",
          ),
        ),
        SizedBox(height: 5),
        BlocField<RegisterCubit, RegisterState, PassStrength>(
          getValue: (state) => state.passStrength,
          buildField: (strength, b) => Row(
            children: [
              // Text("Strength: ", style: Theme.of(context).textTheme.subtitle1),
              // SizedBox(width: 5),
              Expanded(
                child: LinearProgressIndicator(
                  value: getPasswordProgress(strength),
                  color: getStrengthColor(strength),
                  backgroundColor: getStrengthBackground(strength),
                  minHeight: 10,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        BlocField<RegisterCubit, RegisterState, FieldValue>(
          getValue: (state) => state.passRepeat,
          buildField: (value, b) => ZTextField(
            onChanged: b.passRepeatChanged,
            obscureText: true,
            value: value,
            label: "Repeat Password",
          ),
        ),
        SizedBox(height: 20),
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
