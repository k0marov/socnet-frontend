import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocField<B extends StateStreamable<S>, S, Value> extends StatelessWidget {
  final Value Function(S) getValue;
  final Widget Function(Value, B) buildField;
  const BlocField({
    Key? key,
    required this.getValue,
    required this.buildField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      buildWhen: (previous, current) => getValue(previous) != getValue(current),
      builder: (ctx, state) => buildField(getValue(state), ctx.read<B>()),
    );
  }
}
