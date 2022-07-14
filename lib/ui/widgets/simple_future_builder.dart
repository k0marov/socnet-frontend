import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../logic/core/error/failures.dart';

class SimpleFutureBuilder<T> extends StatelessWidget {
  final Future<Either<Failure, T>> future;
  final Widget loading;
  final Widget Function(T) loadedBuilder;
  final Widget Function(Failure) failureBuilder;
  const SimpleFutureBuilder({
    Key? key,
    required this.future,
    required this.loading,
    required this.loadedBuilder,
    required this.failureBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (ctx, AsyncSnapshot<Either<Failure, T>> snapshot) => snapshot.hasData
            ? snapshot.data!.fold(
                (failure) => failureBuilder(failure),
                (result) => loadedBuilder(result),
              )
            : loading);
  }
}
