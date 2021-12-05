part of 'scenario_interface.dart';

class ScenarioTheSameGroup implements ScenarioInterface {
  Map scenarioMap = Map<String, Map<int, StepScenario>>();

  @override
  void addScenario(String scenarioName) {
    scenarioMap[scenarioName] = Map<int, StepScenario>();
  }

  void addStep(String scenarioName, Color color, States state, int degree,
      Duration duration, bool activeInIndependent, int stepNumber) {
    scenarioMap[scenarioName] = {
      stepNumber: StepScenario(
          ledName: "", //[TODO]
          color: color,
          degree: degree,
          duration: duration,
          activeInIndependent: activeInIndependent)
    };
  }

  void removeScenario(String scenarioName) {
    scenarioMap.remove(scenarioName);
  }

  void updateScenario(String scenarioName, Color color, States state,
      int degree, Duration duration, bool activeInIndependent, int stepNumber) {
    scenarioMap[scenarioName][stepNumber] = StepScenario(
        ledName: "", //[TODO]
        color: color,
        degree: degree,
        duration: duration,
        activeInIndependent: activeInIndependent);
  }
}
