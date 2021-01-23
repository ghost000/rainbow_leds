part of 'bl_devices_bloc_bloc.dart';

enum GroupOrIndependent { group, independent }

abstract class BlDevicesBlocEvent extends Equatable {
  const BlDevicesBlocEvent();

  @override
  List<Object> get props => [];
}

class BlDevicesBlocEventInitial extends BlDevicesBlocEvent {
  @override
  String toString() {
    return 'BlDevicesBlocEventInitial';
  }
}

class BlDevicesBlocEventScan extends BlDevicesBlocEvent {
  @override
  String toString() {
    return 'BlDevicesBlocEventScan';
  }
}

class BlDevicesBlocEventGetGroupLedsStates extends BlDevicesBlocEvent {
  @override
  String toString() {
    return 'BlDevicesBlocEventGetGroupLedsStates';
  }
}

class BlDevicesBlocEventGetIndependentLedsStates extends BlDevicesBlocEvent {
  @override
  String toString() {
    return 'BlDevicesBlocEventGetIndependentLedsStates';
  }
}

class BlDevicesBlocEventGetAllLedsStates extends BlDevicesBlocEvent {
  @override
  String toString() {
    return 'BlDevicesBlocEventGetAllLedsStates';
  }
}

class BlDevicesBlocEventAddToGroup extends BlDevicesBlocEvent {
  final LedState ledState;

  const BlDevicesBlocEventAddToGroup(this.ledState);

  @override
  List<Object> get props => [ledState];

  @override
  String toString() {
    return 'BlDevicesBlocEventAddToGroup ledState: $ledState';
  }
}

class BlDevicesBlocEventRemoveFromGroup extends BlDevicesBlocEvent {
  final LedState ledState;

  const BlDevicesBlocEventRemoveFromGroup(this.ledState);

  @override
  List<Object> get props => [ledState];

  @override
  String toString() {
    return 'BlDevicesBlocEventRemoveFromGroup ledState: $ledState';
  }
}

class BlDevicesBlocEventAddToIndependent extends BlDevicesBlocEvent {
  final LedState ledState;

  const BlDevicesBlocEventAddToIndependent(this.ledState);

  @override
  List<Object> get props => [ledState];

  @override
  String toString() {
    return 'BlDevicesBlocEventAddToIndependent ledState: $ledState';
  }
}

class BlDevicesBlocEventRemoveFromIndependent extends BlDevicesBlocEvent {
  final LedState ledState;

  const BlDevicesBlocEventRemoveFromIndependent(this.ledState);

  @override
  List<Object> get props => [ledState];

  @override
  String toString() {
    return 'BlDevicesBlocEventRemoveFromIndependent ledState: $ledState';
  }
}

class BlDevicesBlocEventAddToNotAssigned extends BlDevicesBlocEvent {
  final LedState ledState;

  const BlDevicesBlocEventAddToNotAssigned(this.ledState);

  @override
  List<Object> get props => [ledState];

  @override
  String toString() {
    return 'BlDevicesBlocEventAddToNotAssigned ledState: $ledState';
  }
}

class BlDevicesBlocEventRemoveFromNotAssigned extends BlDevicesBlocEvent {
  final LedState ledState;

  const BlDevicesBlocEventRemoveFromNotAssigned(this.ledState);

  @override
  List<Object> get props => [ledState];

  @override
  String toString() {
    return 'BlDevicesBlocEventRemoveFromNotAssigned ledState: $ledState';
  }
}

class BlDevicesBlocEventUpdateIndependent extends BlDevicesBlocEvent {
  final LedState ledState;

  const BlDevicesBlocEventUpdateIndependent(this.ledState);

  @override
  List<Object> get props => [ledState];

  @override
  String toString() {
    return 'BlDevicesBlocEventUpdateIndependent ledState: $ledState';
  }
}

class BlDevicesBlocEventUpdateGroup extends BlDevicesBlocEvent {
  final LedState ledState;

  const BlDevicesBlocEventUpdateGroup(this.ledState);

  @override
  List<Object> get props => [ledState];

  @override
  String toString() {
    return 'BlDevicesBlocEventUpdateGroup ledState: $ledState';
  }
}

class BlDevicesBlocEventConnect extends BlDevicesBlocEvent {
  final LedState ledState;
  final GroupOrIndependent groupOrIndependent;

  const BlDevicesBlocEventConnect(this.ledState, this.groupOrIndependent);

  @override
  List<Object> get props => [ledState, groupOrIndependent];

  @override
  String toString() {
    return 'BlDevicesBlocEventConnect ledState: $ledState';
  }
}

class BlDevicesBlocEventDisconnect extends BlDevicesBlocEvent {
  final LedState ledState;
  final GroupOrIndependent groupOrIndependent;

  const BlDevicesBlocEventDisconnect(this.ledState, this.groupOrIndependent);

  @override
  List<Object> get props => [ledState, groupOrIndependent];

  @override
  String toString() {
    return 'BlDevicesBlocEventDisconnect ledState: $ledState';
  }
}
