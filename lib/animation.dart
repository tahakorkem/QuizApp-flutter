import 'dart:math';
import 'package:flutter/animation.dart';

class BreathingCurve extends Curve {
  @override
  double transform(double t) =>
      -cos(max(0, min(pi, 2 * pi * t - pi / 3))) * 0.5 + 0.5;
}
