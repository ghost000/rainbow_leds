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

  const BlDevicesBlocStateGroup([this.ledStates = const []]);

  @override
  List<Object> get props => [ledStates];

  @override
  String toString() => 'BlDevicesBlocStateGroup { ledStates: $ledStates }';
}

class BlDevicesBlocStateIndependent extends BlDevicesBlocState {
  final List<LedState> ledStates;

  const BlDevicesBlocStateIndependent([this.ledStates = const []]);

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
      [this.groupLedsStates = const [],
      this.independentLedsStates = const [],
      this.notAssignedLedsStates = const []]);

  @override
  List<Object> get props =>
      [groupLedsStates, independentLedsStates, notAssignedLedsStates];

  @override
  String toString() =>
      'BlDevicesBlocStateAll { groupLedsStates: $groupLedsStates, independentLedsStates: $independentLedsStates, notAssignedLedsStates: $notAssignedLedsStates, }';
}

class BlDevicesBlocStateLoadIndependent extends BlDevicesBlocState {
  final List<LedState> ledStates;

  const BlDevicesBlocStateLoadIndependent([this.ledStates = const []]);

  @override
  List<Object> get props => [ledStates];

  @override
  String toString() =>
      'BlDevicesBlocStateLoadIndependent { ledStates: $ledStates }';
}

class BlDevicesBlocStateLoadGroup extends BlDevicesBlocState {
  final List<LedState> ledStates;

  const BlDevicesBlocStateLoadGroup([this.ledStates = const []]);

  @override
  List<Object> get props => [ledStates];

  @override
  String toString() => 'BlDevicesBlocStateLoadGroup { ledStates: $ledStates }';
}

class BlDevicesBlocStateLoadNotAssigned extends BlDevicesBlocState {
  final List<LedState> ledStates;

  const BlDevicesBlocStateLoadNotAssigned([this.ledStates = const []]);

  @override
  List<Object> get props => [ledStates];

  @override
  String toString() =>
      'BlDevicesBlocStateLoadNotAssigned { ledStates: $ledStates }';
}

class BlDevicesBlocStateLoadFailure extends BlDevicesBlocState {
  @override
  String toString() => 'BlDevicesBlocStateLoadFailure';
}

// class BlDevicesBlocStateAddToGroup extends BlDevicesBlocState {
//   final LedState ledState;

//   const BlDevicesBlocStateAddToGroup(this.ledState);

//   @override
//   List<Object> get props => [ledState];

//   @override
//   String toString() {
//     return 'BlDevicesBlocStateAddToGroup ledState: $ledState';
//   }
// }

// class BlDevicesBlocStateRemoveFromGroup extends BlDevicesBlocState {
//   final LedState ledState;

//   const BlDevicesBlocStateRemoveFromGroup(this.ledState);

//   @override
//   List<Object> get props => [ledState];

//   @override
//   String toString() {
//     return 'BlDevicesBlocStateRemoveFromGroup ledState: $ledState';
//   }
// }

// class BlDevicesBlocStateAddToIndependent extends BlDevicesBlocState {
//   final LedState ledState;

//   const BlDevicesBlocStateAddToIndependent(this.ledState);

//   @override
//   List<Object> get props => [ledState];

//   @override
//   String toString() {
//     return 'BlDevicesBlocStateAddToIndependent ledState: $ledState';
//   }
// }

// class BlDevicesBlocStateRemoveFromIndependent extends BlDevicesBlocState {
//   final LedState ledState;

//   const BlDevicesBlocStateRemoveFromIndependent(this.ledState);

//   @override
//   List<Object> get props => [ledState];

//   @override
//   String toString() {
//     return 'BlDevicesBlocStateRemoveFromIndependent ledState: $ledState';
//   }
// }

// class BlDevicesBlocStateAddToNotAssigned extends BlDevicesBlocState {
//   final LedState ledState;

//   const BlDevicesBlocStateAddToNotAssigned(this.ledState);

//   @override
//   List<Object> get props => [ledState];

//   @override
//   String toString() {
//     return 'BlDevicesBlocStateAddToNotAssigned ledState: $ledState';
//   }
// }

// class BlDevicesBlocStateRemoveFromNotAssigned extends BlDevicesBlocState {
//   final LedState ledState;

//   const BlDevicesBlocStateRemoveFromNotAssigned(this.ledState);

//   @override
//   List<Object> get props => [ledState];

//   @override
//   String toString() {
//     return 'BlDevicesBlocStateRemoveFromNotAssigned ledState: $ledState';
//   }
// }
