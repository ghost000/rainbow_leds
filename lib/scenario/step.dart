import 'package:flutter/material.dart';

import '../bloc/led_state.dart';

class StepScenario {
  String ledName = "";
  Color color = const Color(0xFF000000);
  States state = States.empty;
  int degree = 0;
  Duration duration = Duration.zero;
  bool activeInIndependent = false;

  StepScenario(
      {required String ledName,
      required Color color,
      required int degree,
      required Duration duration,
      required bool activeInIndependent});
}
