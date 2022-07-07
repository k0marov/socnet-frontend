import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../bloc/auth_page_bloc.dart';

class RegisterForm extends StatefulWidget {
  final Failure? failure;
  const RegisterForm({this.failure, Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  String _username = "";
  String _password = "";
  String _passwordRepeat = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.failure != null) Text(widget.failure.toString()),
        Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                onChanged: (value) => setState(() => _username = value),
              ),
              TextFormField(
                onChanged: (value) => setState(() => _password = value),
              ),
              TextFormField(
                onChanged: (value) => setState(() => _passwordRepeat = value),
                validator: (value) => value != _password ? "Passwords don't match" : null,
              ),
              TextButton(
                  child: const Text("Register"),
                  onPressed: _username.isNotEmpty && _password.isNotEmpty && _passwordRepeat.isNotEmpty
                      ? () => _formKey.currentState!.validate()
                          ? context.read<AuthPageBloc>().add(RegistrationRequested(
                                username: _username,
                                password: _password,
                              ))
                          : null
                      : null),
            ])),
      ],
    );
  }
}
