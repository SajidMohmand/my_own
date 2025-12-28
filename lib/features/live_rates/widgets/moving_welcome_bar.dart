import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../../../core/constant_color.dart';

class MovingWelcomeBar extends StatelessWidget {
  final double height;
  const MovingWelcomeBar({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: ConstantColor.gold_gradient,
        )
            : null,
        color: isDark ? null : Colors.transparent,
      ),
      clipBehavior: Clip.hardEdge,
      child: Marquee(
        text: 'Welcome to Amber Zahrat Jewellers    ',
        style: TextStyle(
          fontSize: height * 0.35,
          fontWeight: FontWeight.w900,
          color: Colors.brown,
          letterSpacing: 1.2,
        ),
        scrollAxis: Axis.horizontal,
        blankSpace: 40,
        velocity: 40,       // Increase for faster movement
        startPadding: 10,
        accelerationDuration: const Duration(seconds: 1),
        accelerationCurve: Curves.linear,
        decelerationDuration: const Duration(seconds: 0),
        decelerationCurve: Curves.linear,
      ),
    );
  }
}
