part of 'bl_devices_bloc_bloc.dart';

enum BlDevicesBlocStatus { initial, scan, group, independent, notAssigned }

abstract class BlDevicesBlocState extends Equatable {
  const BlDevicesBlocState();

  @override
  List<Object> get props => [];
}

class BlDevicesBlocStateInitial extends BlDevicesBlocState {}

class BlDevicesBlocStateScan extends BlDevicesBlocState {}

class BlDevicesBlocStateGroup extends BlDevicesBlocState {}

class BlDevicesBlocStateIndependent extends BlDevicesBlocState {}

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
