import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';

import '../../../scenario/scenario_interface.dart';

part 'scenario_bloc_event.dart';
part 'scenario_bloc_state.dart';

class ScenarioBloc extends Bloc<ScenarioBlocEvent, ScenarioBlocState> {
  ScenarioBloc() : super(ScenarioBlocStateInitial()) {
    on<ScenarioBlocEventInitial>((event, emit) {
      emit(ScenarioBlocStateInitial());
    });
  }

  ScenarioIndependent scenarioIndependent = ScenarioIndependent();
  ScenarioTheSameGroup scenarioTheSameGroup = ScenarioTheSameGroup();
  ScenarioDifferentGroup scenarioDifferentGroup = ScenarioDifferentGroup();

  final BehaviorSubject<ScenarioIndependent> _scenarioIndependent =
      BehaviorSubject.seeded(ScenarioIndependent());
  Stream<ScenarioIndependent> get groupLedsStatesStream =>
      _scenarioIndependent.stream;

  final BehaviorSubject<ScenarioTheSameGroup> _scenarioTheSameGroup =
      BehaviorSubject.seeded(ScenarioTheSameGroup());
  Stream<ScenarioTheSameGroup> get independentLedsStatesStream =>
      _scenarioTheSameGroup.stream;

  final BehaviorSubject<ScenarioDifferentGroup> _scenarioDifferentGroup =
      BehaviorSubject.seeded(ScenarioDifferentGroup());
  Stream<ScenarioDifferentGroup> get notAssignedLedsStatesStream =>
      _scenarioDifferentGroup.stream;

  @override
  Future<void> close() {
    _scenarioIndependent.close();
    _scenarioTheSameGroup.close();
    _scenarioDifferentGroup.close();
    return super.close();
  }
}
