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
