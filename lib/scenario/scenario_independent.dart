part of 'scenario_interface.dart';

class ScenarioIndependent implements ScenarioInterface {
  @override
  Map scenarioMap = <String, Map<int, StepScenario>>{};

  @override
  void addScenario(String scenarioName) {
    scenarioMap[scenarioName] = <int, StepScenario>{};
  }

  void addStep(String scenarioName, String ledName, Color color, States state,
      int degree, Duration duration, bool activeInIndependent, int stepNumber) {
    scenarioMap[scenarioName] = {
      ledName: {
        stepNumber: StepScenario(
            ledName: ledName,
            color: color,
            degree: degree,
            duration: duration,
            activeInIndependent: activeInIndependent)
      }
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
    scenarioMap[scenarioName][ledName][stepNumber] = StepScenario(
        ledName: ledName,
        color: color,
        degree: degree,
        duration: duration,
        activeInIndependent: activeInIndependent);
  }
}
