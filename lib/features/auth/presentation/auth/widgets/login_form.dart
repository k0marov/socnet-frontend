import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/core/error/failures.dart';

import '../bloc/auth_page_bloc.dart';

class LoginForm extends StatefulWidget {
  final Failure? failure;
  final String? initialUsername;
  final String? initialPassword;
  const LoginForm(
      {this.failure, this.initialUsername, this.initialPassword, Key? key})
      : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String _username = "";
  String _password = "";

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
              TextButton(
                  child: const Text("Login"),
                  onPressed: _username.isNotEmpty && _password.isNotEmpty
                      ? () => context.read<AuthPageBloc>().add(LoginRequested(
                            username: _username,
                            password: _password,
                          ))
                      : null),
            ])),
      ],
    );
  }
}
