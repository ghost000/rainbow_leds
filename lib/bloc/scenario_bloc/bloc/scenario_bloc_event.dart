part of 'scenario_bloc_bloc.dart';

abstract class ScenarioBlocEvent extends Equatable {
  const ScenarioBlocEvent();

  @override
  List<Object> get props => [];
}

class ScenarioBlocEventInitial extends ScenarioBlocEvent {
  @override
  String toString() {
    return 'ScenarioBlocEventInitial';
  }
}

class AddScenarioIndependent extends ScenarioBlocEvent {
  final String scenarioName;

  const AddScenarioIndependent(this.scenarioName);

  @override
  List<Object> get props => [scenarioName];

  @override
  String toString() {
    return 'AddScenarioIndependent scenarioName: $scenarioName';
  }
}

class RemoveScenarioIndependent extends ScenarioBlocEvent {
  final String scenarioName;

  const RemoveScenarioIndependent(this.scenarioName);

  @override
  List<Object> get props => [scenarioName];

  @override
  String toString() {
    return 'RemoveScenarioIndependent scenarioName: $scenarioName';
  }
}

class AddStepScenarioIndependent extends ScenarioBlocEvent {
  @override
  String toString() {
    return 'AddStepScenarioIndependent';
  }
}

class UpdateScenarioIndependent extends ScenarioBlocEvent {
  @override
  String toString() {
    return 'UpdateScenarioIndependent';
  }
}

class AddScenarioTheSameGroup extends ScenarioBlocEvent {
  final String scenarioName;

  const AddScenarioTheSameGroup(this.scenarioName);

  @override
  List<Object> get props => [scenarioName];

  @override
  String toString() {
    return 'AddScenarioTheSameGroup scenarioName: $scenarioName';
  }
}

class RemoveScenarioTheSameGroup extends ScenarioBlocEvent {
  final String scenarioName;

  const RemoveScenarioTheSameGroup(this.scenarioName);

  @override
  List<Object> get props => [scenarioName];

  @override
  String toString() {
    return 'RemoveScenarioTheSameGroup scenarioName: $scenarioName';
  }
}

class AddStepScenarioTheSameGroup extends ScenarioBlocEvent {
  @override
  String toString() {
    return 'AddStepScenarioTheSameGroup';
  }
}

class UpdateScenarioTheSameGroup extends ScenarioBlocEvent {
  @override
  String toString() {
    return 'UpdateScenarioTheSameGroup';
  }
}

class AddScenarioDifferentGroup extends ScenarioBlocEvent {
  final String scenarioName;

  const AddScenarioDifferentGroup(this.scenarioName);

  @override
  List<Object> get props => [scenarioName];

  @override
  String toString() {
    return 'AddScenarioDifferentGroup scenarioName: $scenarioName';
  }
}

class RemoveScenarioDifferentGroup extends ScenarioBlocEvent {
  final String scenarioName;

  const RemoveScenarioDifferentGroup(this.scenarioName);

  @override
  List<Object> get props => [scenarioName];

  @override
  String toString() {
    return 'RemoveScenarioDifferentGroup scenarioName: $scenarioName';
  }
}

class AddStepScenarioDifferentGroup extends ScenarioBlocEvent {
  @override
  String toString() {
    return 'AddStepScenarioTheSameGroup';
  }
}

class UpdateScenarioDifferentGroup extends ScenarioBlocEvent {
  @override
  String toString() {
    return 'UpdateScenarioDifferentGroup';
  }
}
