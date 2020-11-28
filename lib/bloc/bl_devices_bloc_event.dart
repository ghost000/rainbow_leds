part of 'bl_devices_bloc_bloc.dart';

abstract class BlDevicesBlocEvent extends Equatable {
  const BlDevicesBlocEvent();

  @override
  List<Object> get props => [];
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
