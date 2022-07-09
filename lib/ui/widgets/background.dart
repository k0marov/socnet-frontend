import 'package:flutter/material.dart';
import 'package:socnet/ui/theme.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(
        top: -75,
        left: -125,
        child: _Circle(size: 200, color: customBlue),
      ),
      Positioned(
        bottom: 100,
        left: -100,
        child: _Circle(size: 150, color: customRed),
      ),
      Positioned(
        bottom: -25,
        left: 200,
        child: _Circle(size: 75, color: customCyan),
      ),
      Positioned(
        bottom: 50,
        right: -50,
        child: _Circle(size: 125, color: customGreen),
      ),
      Positioned(
        top: 100,
        right: -75,
        child: _Circle(size: 100, color: customPink),
      ),
      child,
    ]);
  }
}

class _Circle extends StatelessWidget {
  final double size;
  final Color color;
  const _Circle({Key? key, required this.size, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
