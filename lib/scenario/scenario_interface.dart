import 'package:flutter/material.dart';

import '../bloc/led_state.dart';
import 'step.dart';

part 'scenario_different_group.dart';
part 'scenario_independent.dart';
part 'scenario_the_same_group.dart';

abstract class ScenarioInterface {
  late Map scenarioMap;

  void addScenario(String scenarioName);

  void removeScenario(String scenarioName);
}
