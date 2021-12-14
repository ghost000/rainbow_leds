import 'package:bloc/bloc.dart' show Bloc, Emitter;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show Color;
import 'package:flutter_blue/flutter_blue.dart' show BluetoothCharacteristic, FlutterBlue;
import 'package:logger/logger.dart' show Logger;
import 'package:rxdart/rxdart.dart' show BehaviorSubject;

import 'led_state.dart';

part 'bl_devices_bloc_event.dart';
part 'bl_devices_bloc_state.dart';

class Light {
  final String transmitUuid = 'f000aa61-0451-4000-b000-000000000000';

  final Map<String, int> packetTypes = {
    'set_color': 0xa1,
    'set_white': 0xaa,
    'power_off': 0xa3,
  };
}

class BlDevicesBlocBloc extends Bloc<BlDevicesBlocEvent, BlDevicesBlocState> {
  BlDevicesBlocBloc() : super(BlDevicesBlocStateInitial()) {
    on<BlDevicesBlocEventAddToGroup>((event, emit){
      _mapLedStateAddedToGroupToState(event, emit);
    });
    on<BlDevicesBlocEventRemoveFromGroup>((event, emit){
      _mapLedStateRemovedFromGroupToState(event, emit);
    });
    on<BlDevicesBlocEventAddToIndependent>((event, emit){
      _mapLedStateAddedToIndependentState(event, emit);
    });
    on<BlDevicesBlocEventRemoveFromIndependent>((event, emit){
      _mapLedStateRemovedFromIndependentToState(event, emit);
    });
    on<BlDevicesBlocEventAddToNotAssigned>((event, emit){
      _mapLedStateAddedToNotAssignedToState(event, emit);
    });
    on<BlDevicesBlocEventRemoveFromNotAssigned>((event, emit){
      _mapLedStateRemovedFromNotAssignedToState(event, emit);
    });
    on<BlDevicesBlocEventGetGroupLedsStates>((event, emit) {
      emit(BlDevicesBlocStateGroup(groupLedsStates.toList()));
    });
    on<BlDevicesBlocEventGetIndependentLedsStates>((event, emit) {
      emit(BlDevicesBlocStateIndependent(independentLedsStates.toList()));
    });
    on<BlDevicesBlocEventGetAllLedsStates>((event, emit) {
      emit(BlDevicesBlocStateAll(groupLedsStates.toList(),
          independentLedsStates.toList(), notAssignedLedsStates.toList()));
    });
    on<BlDevicesBlocEventInitial>((event, emit) {
      emit(BlDevicesBlocStateInitial());
    });
    on<BlDevicesBlocEventScan>((event, emit) {
      emit(BlDevicesBlocStateScan());
    });
    on<BlDevicesBlocEventUpdateIndependent>((event, emit){
      _mapLedStateUpdateIndependent(event, emit);
    });
    on<BlDevicesBlocEventUpdateGroup>((event, emit){
      _mapLedStateUpdateGroup(event, emit);
    });
    on<BlDevicesBlocEventConnect>((event, emit){
      _mapLedStateConnect(event, emit);
    });
    on<BlDevicesBlocEventDisconnect>((event, emit){
      _mapLedStateDisconnect(event, emit);
    });

    listenFlutterBlueDebug();
  }

  String transmitUuid = 'f000aa61-0451-4000-b000-000000000000';
  Set<LedState> groupLedsStates = {};
  Set<LedState> independentLedsStates = {};
  Set<LedState> notAssignedLedsStates = {};

  final BehaviorSubject<Set<LedState>> _groupLedsStates =
      BehaviorSubject.seeded({});

  Stream<Set<LedState>> get groupLedsStatesStream => _groupLedsStates.stream;
  final BehaviorSubject<Set<LedState>> _independentLedsStates =
      BehaviorSubject.seeded({});

  Stream<Set<LedState>> get independentLedsStatesStream =>
      _independentLedsStates.stream;
  final BehaviorSubject<Set<LedState>> _notAssignedLedsStates =
      BehaviorSubject.seeded({});

  Stream<Set<LedState>> get notAssignedLedsStatesStream =>
      _notAssignedLedsStates.stream;

  Future<void> listenFlutterBlueDebug() async {
    FlutterBlue.instance.scanResults.listen((event) async {
      for (final scanResult in event) {
        //if (scanResult.device.id.id != null &&
        if (scanResult.device.id.id.isNotEmpty //&&
            //scanResult.device.name.contains('YONGNUO')) { // TODO search case for releasing. I will add console argument to manage this.
        && scanResult.device.name.isNotEmpty) {
          if (groupLedsStates
                  .where((element) => element.name == scanResult.device.id.id)
                  .isEmpty &&
              independentLedsStates
                  .where((element) => element.name == scanResult.device.id.id)
                  .isEmpty &&
              notAssignedLedsStates
                  .where((element) => element.name == scanResult.device.id.id)
                  .isEmpty) {
            add(BlDevicesBlocEventAddToNotAssigned(ledState: LedState(
                name: scanResult.device.id.id,
                secondName: scanResult.device.name,
                bluetoothDevice: scanResult.device)));
          }
        }
      }
    });
  }

  // void listenFlutterBlue(){
  //   FlutterBlue.instance.scanResults.listen((event){
  //     for (final scanResult in event) {
  //       if (scanResult.device.id.id != null &&
  //           scanResult.device.id.id.isNotEmpty &&
  //           scanResult.device.name.contains('YONGNUO')) {
  //         BluetoothCharacteristic characteristic;
  //         await scanResult.device.connect();
  //         await scanResult.device.discoverServices().then((value) {
  //           value.forEach((element) {
  //             element.characteristics.forEach((element) {
  //               if (element.uuid.toString() == transmitUuid) {
  //                 characteristic = element;
  //                 if (groupLedsStates
  //                         .where((element) => element.name == scanResult.device.id.id)
  //                         .isEmpty &&
  //                     independentLedsStates
  //                         .where((element) => element.name == scanResult.device.id.id)
  //                         .isEmpty &&
  //                     notAssignedLedsStates
  //                         .where((element) => element.name == scanResult.device.id.id)
  //                         .isEmpty) {
  //                   add(BlDevicesBlocEventAddToNotAssigned(LedState(
  //                       name: scanResult.device.id.id,
  //                       characteristic: characteristic,
  //                       bluetoothDevice: scanResult.device)));
  //                 }
  //               }
  //             });
  //           });
  //         });
  //       }
  //     }
  //   });
  // }

  @override
  Future<void> close(){
    for (final element in groupLedsStates) {
      element.ledState = States.disconnect;
      element.updateLightManager();
    }
    for (final element in independentLedsStates) {
      element.ledState = States.disconnect;
      element.updateLightManager();
    }
    for (final element in notAssignedLedsStates) {
      element.ledState = States.disconnect;
      element.updateLightManager();
    }

    _groupLedsStates.close();
    _independentLedsStates.close();
    _notAssignedLedsStates.close();
    return super.close();
  }

  // @override
  // Stream<BlDevicesBlocState> mapEventToState(
  //   BlDevicesBlocEvent event,
  // ) async* {
  //   if (event is BlDevicesBlocEventAddToGroup) {
  //     yield* _mapLedStateAddedToGroupToState(event);
  //   } else if (event is BlDevicesBlocEventRemoveFromGroup) {
  //     yield* _mapLedStateRemovedFromGroupToState(event);
  //   } else if (event is BlDevicesBlocEventAddToIndependent) {
  //     yield* _mapLedStateAddedToIndependentState(event);
  //   } else if (event is BlDevicesBlocEventRemoveFromIndependent) {
  //     yield* _mapLedStateRemovedFromIndependentToState(event);
  //   } else if (event is BlDevicesBlocEventAddToNotAssigned) {
  //     yield* _mapLedStateAddedToNotAssignedToState(event);
  //   } else if (event is BlDevicesBlocEventRemoveFromNotAssigned) {
  //     yield* _mapLedStateRemovedFromNotAssignedToState(event);
  //   } else if (event is BlDevicesBlocEventGetGroupLedsStates) {
  //     yield BlDevicesBlocStateGroup(groupLedsStates.toList());
  //   } else if (event is BlDevicesBlocEventGetIndependentLedsStates) {
  //     yield BlDevicesBlocStateIndependent(independentLedsStates.toList());
  //   } else if (event is BlDevicesBlocEventGetAllLedsStates) {
  //     yield BlDevicesBlocStateAll(groupLedsStates.toList(),
  //         independentLedsStates.toList(), notAssignedLedsStates.toList());
  //   } else if (event is BlDevicesBlocEventInitial) {
  //     yield BlDevicesBlocStateInitial();
  //   } else if (event is BlDevicesBlocEventScan) {
  //     yield BlDevicesBlocStateScan(); //TODO add scaning in this state [FEATURE]
  //   } else if (event is BlDevicesBlocEventUpdateIndependent) {
  //     yield* _mapLedStateUpdateIndependent(event);
  //   } else if (event is BlDevicesBlocEventUpdateGroup) {
  //     yield* _mapLedStateUpdateGroup(event);
  //   } else if (event is BlDevicesBlocEventConnect) {
  //     yield* _mapLedStateConnect(event);
  //   } else if (event is BlDevicesBlocEventDisconnect) {
  //     yield* _mapLedStateDisconnect(event);
  //   }
  // }

  void _mapLedStateAddedToGroupToState(
      BlDevicesBlocEventAddToGroup event, Emitter<BlDevicesBlocState> emit) {
    try {
      groupLedsStates.add(event.ledState);
      notAssignedLedsStates.remove(event.ledState);
      independentLedsStates.remove(event.ledState);
      _notAssignedLedsStates.add(notAssignedLedsStates);
      _independentLedsStates.add(independentLedsStates);
      _groupLedsStates.add(groupLedsStates);
      emit(BlDevicesBlocStateLoadGroup(groupLedsStates.toList()));
    } on Exception catch (_) {
      emit(BlDevicesBlocStateLoadFailure());
    }
  }

  void _mapLedStateRemovedFromGroupToState(
      BlDevicesBlocEventRemoveFromGroup event,
      Emitter<BlDevicesBlocState> emit){
    try {
      groupLedsStates.remove(event.ledState);
      _groupLedsStates.add(groupLedsStates);
      emit(BlDevicesBlocStateLoadGroup(groupLedsStates.toList()));
    } on Exception catch (_) {
      emit(BlDevicesBlocStateLoadFailure());
    }
  }

  void _mapLedStateAddedToIndependentState(
      BlDevicesBlocEventAddToIndependent event,
      Emitter<BlDevicesBlocState> emit){
    try {
      independentLedsStates.add(event.ledState);
      groupLedsStates.remove(event.ledState);
      notAssignedLedsStates.remove(event.ledState);
      _notAssignedLedsStates.add(notAssignedLedsStates);
      _independentLedsStates.add(independentLedsStates);
      _groupLedsStates.add(groupLedsStates);
      emit(
          BlDevicesBlocStateLoadIndependent(independentLedsStates.toList()));
    } on Exception catch (_) {
      emit(BlDevicesBlocStateLoadFailure());
    }
  }

  void _mapLedStateRemovedFromIndependentToState(
      BlDevicesBlocEventRemoveFromIndependent event,
      Emitter<BlDevicesBlocState> emit) {
    try {
      independentLedsStates.remove(event.ledState);
      _independentLedsStates.add(independentLedsStates);
      emit(
          BlDevicesBlocStateLoadIndependent(independentLedsStates.toList()));
    } on Exception catch (_) {
      emit(BlDevicesBlocStateLoadFailure());
    }
  }

  void _mapLedStateAddedToNotAssignedToState(
      BlDevicesBlocEventAddToNotAssigned event,
      Emitter<BlDevicesBlocState> emit) {
    try {
      final logger = Logger();

      logger.d(event);
      logger.e(event.ledState);
      notAssignedLedsStates.add(event.ledState);
      independentLedsStates.remove(event.ledState);
      groupLedsStates.remove(event.ledState);
      _notAssignedLedsStates.add(notAssignedLedsStates);
      _independentLedsStates.add(independentLedsStates);
      _groupLedsStates.add(groupLedsStates);
      emit(
          BlDevicesBlocStateLoadNotAssigned(notAssignedLedsStates.toList()));
    } on Exception catch (_) {
      emit(BlDevicesBlocStateLoadFailure());
    }
  }

  void _mapLedStateRemovedFromNotAssignedToState(
      BlDevicesBlocEventRemoveFromNotAssigned event,
      Emitter<BlDevicesBlocState> emit){
    try {
      notAssignedLedsStates.remove(event.ledState);
      _notAssignedLedsStates.add(notAssignedLedsStates);
      emit(
          BlDevicesBlocStateLoadNotAssigned(notAssignedLedsStates.toList()));
    } on Exception catch (_) {
      emit(BlDevicesBlocStateLoadFailure());
    }
  }

  void _mapLedStateUpdateIndependent(
      BlDevicesBlocEventUpdateIndependent event,
      Emitter<BlDevicesBlocState> emit){
    try {
      for (final ledState in independentLedsStates) {
        if (ledState.name == event.ledState.name) {
          updateLeStateParam(event.ledState, ledState);
        }
      }
      _independentLedsStates.add(independentLedsStates);
      emit(
          BlDevicesBlocStateUpdateIndependent(independentLedsStates.toList()));
    } on Exception catch (_) {
      emit(BlDevicesBlocStateLoadFailure());
    }
  }

  void _mapLedStateUpdateGroup(BlDevicesBlocEventUpdateGroup event,
      Emitter<BlDevicesBlocState> emit){
    try {
      for (final ledState in groupLedsStates) {
        updateLeStateParam(event.ledState, ledState);
      }
      _groupLedsStates.add(groupLedsStates);
      emit(BlDevicesBlocStateUpdateGroup(groupLedsStates.toList()));
    } on Exception catch (_) {
      emit(BlDevicesBlocStateLoadFailure());
    }
  }

  void _mapLedStateConnect(
      BlDevicesBlocEventConnect event, Emitter<BlDevicesBlocState> emit) async {
    try {
      BluetoothCharacteristic characteristic;
      await event.ledState.ledBluetoothDevice!.connect();
      await event.ledState.ledBluetoothDevice!.discoverServices().then((value) {
        for (final element in value) {
          for (final characteristicElement in element.characteristics) {
            if (characteristicElement.uuid.toString() == transmitUuid) {
              characteristic = characteristicElement;
              if (event.groupOrIndependent == GroupOrIndependent.group) {
                groupLedsStates
                    .where((characteristicElement) =>
                        characteristicElement.name == event.ledState.name)
                    .first
                    .ledCharacteristic = characteristic;
              } else if (event.groupOrIndependent ==
                  GroupOrIndependent.independent) {
                independentLedsStates
                    .where((characteristicElement) =>
                        characteristicElement.name == event.ledState.name)
                    .first
                    .ledCharacteristic = characteristic;
              }
            }
          }
        }
      });
      if (event.groupOrIndependent == GroupOrIndependent.group) {
        emit(BlDevicesBlocStateConnect(groupLedsStates.toList()));
      } else if (event.groupOrIndependent == GroupOrIndependent.independent) {
        emit(BlDevicesBlocStateConnect(independentLedsStates.toList()));
      }
    } on Exception catch (_) {
      emit(BlDevicesBlocStateLoadFailure());
    }
  }

  void _mapLedStateDisconnect(BlDevicesBlocEventDisconnect event,
      Emitter<BlDevicesBlocState> emit) async {
    try {
      //TODO implement removing ledState afetr disconnect
      await event.ledState.ledBluetoothDevice!.disconnect();
      if (event.groupOrIndependent == GroupOrIndependent.group) {
        // groupLedsStates.remove(event.ledState);
        // _groupLedsStates.add(groupLedsStates);
        // notAssignedLedsStates.add(event.ledState);
        // _notAssignedLedsStates.add(notAssignedLedsStates);
        emit(BlDevicesBlocStateDisconnect(groupLedsStates.toList()));
      } else if (event.groupOrIndependent == GroupOrIndependent.independent) {
        // independentLedsStates.remove(event.ledState);
        // _independentLedsStates.add(independentLedsStates);
        // notAssignedLedsStates.add(event.ledState);
        // _notAssignedLedsStates.add(notAssignedLedsStates);
        emit(
            BlDevicesBlocStateDisconnect(independentLedsStates.toList()));
      }
    } on Exception catch (_) {
      emit(BlDevicesBlocStateLoadFailure());
    }
  }

  void updateLeStateParam(LedState eventLedState, LedState ledState) {
    var update = false;
    if (eventLedState.activeInIndependent != ledState.activeInIndependent &&
        eventLedState.state == States.active) {
      ledState.activeInIndependent = eventLedState.activeInIndependent;
      update = false;
    }
    if (eventLedState.ledCharacteristic != ledState.ledCharacteristic) {
      ledState.ledCharacteristic = eventLedState.ledCharacteristic;
    }
    if (eventLedState.color != const Color(0xFFFFFFFF) &&
        eventLedState.color != ledState.color) {
      ledState.color = eventLedState.color;
      update = true;
    }
    if (eventLedState.state != States.empty &&
        eventLedState.state != ledState.state &&
        eventLedState.state != States.active) {
      ledState.ledState = eventLedState.state;
      update = true;
    }
    if (eventLedState.degree != ledState.degree) {
      ledState.degree = eventLedState.degree;
      update = true;
    }
    if (update) {
      ledState.updateLightManager();
    }
  }
}
