import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/core/error/failures.dart';

class FailureListener<B extends StateStreamable<S>, S> extends StatelessWidget {
  final Failure? Function(S) getFailure;
  final Widget child;
  const FailureListener({Key? key, required this.getFailure, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listenWhen: (previous, current) => getFailure(previous) != getFailure(current),
      listener: (ctx, state) => getFailure(state) != null
          ? showDialog(
              context: ctx,
              builder: (ctx) => AlertDialog(
                title: Text("failure"),
                content: Text("Please, try again later."),
                actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("OK"))],
              ),
            )
          : null,
      child: child,
    );
  }
}
