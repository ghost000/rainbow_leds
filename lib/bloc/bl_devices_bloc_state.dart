part of 'bl_devices_bloc_bloc.dart';

enum BlDevicesBlocStatus { initial, scan, group, independent, notAssigned }

abstract class BlDevicesBlocState extends Equatable {
  const BlDevicesBlocState();

  @override
  List<Object> get props => [];
}

class BlDevicesBlocStateInitial extends BlDevicesBlocState {}

class BlDevicesBlocStateScan extends BlDevicesBlocState {}

class BlDevicesBlocStateGroup extends BlDevicesBlocState {
  final List<LedState> ledStates;

  const BlDevicesBlocStateGroup(this.ledStates);

  @override
  List<Object> get props => [ledStates];

  @override
  String toString() => 'BlDevicesBlocStateGroup { ledStates: $ledStates }';
}

class BlDevicesBlocStateIndependent extends BlDevicesBlocState {
  final List<LedState> ledStates;

  const BlDevicesBlocStateIndependent(this.ledStates);

  @override
  List<Object> get props => [ledStates];

  @override
  String toString() =>
      'BlDevicesBlocStateIndependent { ledStates: $ledStates }';
}

class BlDevicesBlocStateAll extends BlDevicesBlocState {
  final List<LedState> groupLedsStates;
  final List<LedState> independentLedsStates;
  final List<LedState> notAssignedLedsStates;

  const BlDevicesBlocStateAll(
      this.groupLedsStates,
      this.independentLedsStates,
      this.notAssignedLedsStates);

  @override
  List<Object> get props =>
      [groupLedsStates, independentLedsStates, notAssignedLedsStates];

  @override
  String toString() =>
      'BlDevicesBlocStateAll { groupLedsStates: $groupLedsStates, independentLedsStates: $independentLedsStates, notAssignedLedsStates: $notAssignedLedsStates, }';
}

class BlDevicesBlocStateLoadIndependent extends BlDevicesBlocState {
  final List<LedState> ledStates;

  const BlDevicesBlocStateLoadIndependent(this.ledStates);

  @override
  List<Object> get props => [ledStates];

  @override
  String toString() =>
      'BlDevicesBlocStateLoadIndependent { ledStates: $ledStates }';
}

class BlDevicesBlocStateLoadGroup extends BlDevicesBlocState {
  final List<LedState> ledStates;

  const BlDevicesBlocStateLoadGroup(this.ledStates);

  @override
  List<Object> get props => [ledStates];

  @override
  String toString() => 'BlDevicesBlocStateLoadGroup { ledStates: $ledStates }';
}

class BlDevicesBlocStateLoadNotAssigned extends BlDevicesBlocState {
  final List<LedState> ledStates;

  const BlDevicesBlocStateLoadNotAssigned(this.ledStates);

  @override
  List<Object> get props => [ledStates];

  @override
  String toString() =>
      'BlDevicesBlocStateLoadNotAssigned { ledStates: $ledStates }';
}

class BlDevicesBlocStateUpdateIndependent extends BlDevicesBlocState {
  final List<LedState> ledStates;

  const BlDevicesBlocStateUpdateIndependent(this.ledStates);

  @override
  List<Object> get props => [ledStates];

  @override
  String toString() =>
      'BlDevicesBlocStateUpdateIndependent { ledStates: $ledStates }';
}

class BlDevicesBlocStateUpdateGroup extends BlDevicesBlocState {
  final List<LedState> ledStates;

  const BlDevicesBlocStateUpdateGroup(this.ledStates);

  @override
  List<Object> get props => [ledStates];

  @override
  String toString() =>
      'BlDevicesBlocStateUpdateGroup { ledStates: $ledStates }';
}

class BlDevicesBlocStateLoadFailure extends BlDevicesBlocState {
  @override
  String toString() => 'BlDevicesBlocStateLoadFailure';
}

class BlDevicesBlocStateConnect extends BlDevicesBlocState {
  final List<LedState> ledStates;

  const BlDevicesBlocStateConnect(this.ledStates);

  @override
  List<Object> get props => [ledStates];

  @override
  String toString() => 'BlDevicesBlocStateConnect { ledStates: $ledStates }';
}

class BlDevicesBlocStateDisconnect extends BlDevicesBlocState {
  final List<LedState> ledStates;

  const BlDevicesBlocStateDisconnect(this.ledStates);

  @override
  List<Object> get props => [ledStates];

  @override
  String toString() => 'BlDevicesBlocStateDisconnect { ledStates: $ledStates }';
}
