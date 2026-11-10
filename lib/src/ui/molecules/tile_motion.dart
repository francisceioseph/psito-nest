import 'package:flutter/material.dart';

/// How long a bird takes to slide to its new place.
const slideTime = Duration(milliseconds: 120);

/// Grows in when an egg is laid or a bird changes.
class Hatch extends StatelessWidget {
  const Hatch({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: .55, end: 1),
    duration: const Duration(milliseconds: 190),
    curve: Curves.easeOutBack,
    builder: (context, scale, content) =>
        Transform.scale(scale: scale, child: content),
    child: child,
  );
}

/// What a merged tile leaves behind, gone once it arrives.
class Fading extends StatelessWidget {
  const Fading({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 1, end: 0),
    duration: slideTime,
    curve: const Interval(.7, 1),
    builder: (context, opacity, content) =>
        Opacity(opacity: opacity, child: content),
    child: child,
  );
}
