import 'package:flutter/material.dart';
import '../bloc/led_state.dart';

class StepScenario {
  String ledName;
  Color color;
  States state;
  int degree;
  Duration duration;
  bool activeInIndependent;

  StepScenario(
      {String ledName,
      Color color,
      int degree,
      Duration duration,
      bool activeInIndependent});
}
