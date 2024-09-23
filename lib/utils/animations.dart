// animations.dart
import 'package:flutter/material.dart';

class AnimationUtils {
  // Fade animation
  static AnimationController createFadeAnimationController(
      {required TickerProvider vsync,
      Duration duration = const Duration(seconds: 2)}) {
    return AnimationController(
      duration: duration,
      vsync: vsync,
    );
  }

  static Animation<double> createFadeAnimation(AnimationController controller,
      {double begin = 0.0, double end = 1.0}) {
    return CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ).drive(Tween(begin: begin, end: end));
  }

  // Slide animation
  static Animation<Offset> createSlideAnimation(AnimationController controller,
      {Offset begin = const Offset(0, 1), Offset end = Offset.zero}) {
    return Tween<Offset>(begin: begin, end: end).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }

  // Scale animation
  static Animation<double> createScaleAnimation(AnimationController controller,
      {double begin = 0.0, double end = 1.0}) {
    return Tween<double>(begin: begin, end: end).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }

  // Rotation animation
  static Animation<double> createRotationAnimation(
      AnimationController controller,
      {double begin = 0.0,
      double end = 1.0}) {
    return Tween<double>(begin: begin, end: end).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
  }
}
