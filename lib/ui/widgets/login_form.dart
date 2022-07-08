import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socnet/logic/features/auth/presentation/login_cubit/login_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  LoginCubit _loginCubit(BuildContext context) => context.read<LoginCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) => previous.failure != current.failure,
      listener: (ctx, state) => state.failure != null
          ? showDialog(
              context: ctx,
              builder: (ctx) => AlertDialog(
                title: Text("failure"),
                content: Text("Please, try again later."),
                actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("OK"))],
              ),
            )
          : null,
      child: Column(children: [
        BlocBuilder<LoginCubit, LoginState>(
          buildWhen: (previous, current) => previous.curUsername != current.curUsername,
          builder: (ctx, state) => TextField(
            onChanged: ctx.read<LoginCubit>().usernameChanged,
            decoration: InputDecoration(
              errorText: state.curUsername.failure?.code,
            ),
          ),
        ),
        BlocBuilder<LoginCubit, LoginState>(
          buildWhen: (previous, current) => previous.curPassword != current.curPassword,
          builder: (ctx, state) => TextField(
            onChanged: ctx.read<LoginCubit>().passwordChanged,
            obscureText: true,
            decoration: InputDecoration(
              errorText: state.curPassword.failure?.code,
            ),
          ),
        ),
        BlocBuilder<LoginCubit, LoginState>(
          buildWhen: (previous, current) => previous.canBeSubmitted != current.canBeSubmitted,
          builder: (ctx, state) => TextButton(
            onPressed: state.canBeSubmitted ? ctx.read<LoginCubit>().loginPressed : null,
            child: Text("Login"),
          ),
        ),
      ]),
    );
  }
}
// // TextField(
// //   onChanged: (name) => context.read<LoginCubit>().usernameChanged(name),
// //   // decoration: InputDecoration(
// //   //   errorText: state.curUsername.failure?.code,
// //   // ),
// // ),
// // TextField(
// //   onChanged: (pass) => context.read<LoginCubit>().passwordChanged(pass),
// //   // obscureText: false,
// //   // decoration: InputDecoration(
// //   //   errorText: state.curPassword.failure?.code,
// //   // ),
// // ),
// TextButton(
// onPressed: () => context.read<LoginCubit>().usernameChanged("username"),
// child: Text("Username"),
// ),
// TextButton(
// onPressed: state.canBeSubmitted ? _loginCubit(ctx).loginPressed : null,
// child: Text("Login"),
// ),
