part of 'scenario_bloc_bloc.dart';

abstract class ScenarioBlocState extends Equatable {
  const ScenarioBlocState();

  @override
  List<Object> get props => [];
}

class ScenarioBlocStateInitial extends ScenarioBlocState {}
