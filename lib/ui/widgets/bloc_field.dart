import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocField<B extends StateStreamable<S>, S, Value, Method> extends StatelessWidget {
  final Value Function(S) getValue;
  final Method Function(B) getMethod;
  final Widget Function(Value, Method) buildField;
  const BlocField({
    Key? key,
    required this.getValue,
    required this.getMethod,
    required this.buildField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      buildWhen: (previous, current) => getValue(previous) != getValue(current),
      builder: (ctx, state) => buildField(getValue(state), getMethod(ctx.read<B>())),
      // builder: (ctx, state) => TextField(
      //   onChanged: getOnChanged(context.read<B>()),
      //   decoration: InputDecoration(
      //     errorText: getField(state).failure?.code,
      //   ),
      // ),
    );
  }
}
