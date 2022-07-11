import 'package:flutter/material.dart';

class ZStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget loading;
  final Widget Function(T) loadedBuilder;
  const ZStreamBuilder({
    Key? key,
    required this.stream,
    required this.loading,
    required this.loadedBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (ctx, AsyncSnapshot<T> snapshot) => snapshot.hasData ? loadedBuilder(snapshot.data!) : loading,
    );
  }
}
