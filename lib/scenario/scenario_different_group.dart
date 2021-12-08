part of 'scenario_interface.dart';

class ScenarioDifferentGroup implements ScenarioInterface {
  @override
  Map scenarioMap = <String, Map<String, Map<int, StepScenario>>>{};

  @override
  void addScenario(String scenarioName) {
    scenarioMap[scenarioName] = <String, Map<int, StepScenario>>{};
  }

  void addStep(String scenarioName, String ledName, Color color, States state,
      int degree, Duration duration, bool activeInIndependent, int stepNumber) {
    scenarioMap[scenarioName] = {
      stepNumber: StepScenario(
          ledName: ledName,
          color: color,
          degree: degree,
          duration: duration,
          activeInIndependent: activeInIndependent)
    };
  }

  @override
  void removeScenario(String scenarioName) {
    scenarioMap.remove(scenarioName);
  }

  void updateScenario(
      String scenarioName,
      String ledName,
      Color color,
      States state,
      int degree,
      Duration duration,
      bool activeInIndependent,
      int stepNumber) {
    scenarioMap[scenarioName][stepNumber] = StepScenario(
        ledName: ledName,
        color: color,
        degree: degree,
        duration: duration,
        activeInIndependent: activeInIndependent);
  }
}
