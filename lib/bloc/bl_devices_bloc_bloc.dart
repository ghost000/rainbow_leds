import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';

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
    on<BlDevicesBlocEventAddToGroup>(_mapLedStateAddedToGroupToState);
    on<BlDevicesBlocEventRemoveFromGroup>(_mapLedStateRemovedFromGroupToState);
    on<BlDevicesBlocEventAddToIndependent>(_mapLedStateAddedToIndependentState);
    on<BlDevicesBlocEventRemoveFromIndependent>(
        _mapLedStateRemovedFromIndependentToState);
    on<BlDevicesBlocEventAddToNotAssigned>(
        _mapLedStateAddedToNotAssignedToState);
    on<BlDevicesBlocEventRemoveFromNotAssigned>(
        _mapLedStateRemovedFromNotAssignedToState);
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
    on<BlDevicesBlocEventUpdateIndependent>(_mapLedStateUpdateIndependent);
    on<BlDevicesBlocEventUpdateGroup>(_mapLedStateUpdateGroup);
    on<BlDevicesBlocEventConnect>(_mapLedStateConnect);
    on<BlDevicesBlocEventDisconnect>(_mapLedStateDisconnect);

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
            ) {
          if (groupLedsStates
                  .where((element) => element.name == scanResult.device.id.id)
                  .isEmpty &&
              independentLedsStates
                  .where((element) => element.name == scanResult.device.id.id)
                  .isEmpty &&
              notAssignedLedsStates
                  .where((element) => element.name == scanResult.device.id.id)
                  .isEmpty) {
            var tempLedState = LedState(
                name: scanResult.device.id.id,
                active: false,
                color: const Color(0xFF000000),
                degree: 0,
                state: States.empty);
            tempLedState.ledBluetoothDevice = scanResult.device;
            add(BlDevicesBlocEventAddToNotAssigned(ledState: tempLedState));
          }
        }
      }
    });
  }

  // Future<void> listenFlutterBlue() async {
  //   FlutterBlue.instance.scanResults.listen((event) async {
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
  Future<void> close() {
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
      return emit(BlDevicesBlocStateLoadGroup(groupLedsStates.toList()));
    } catch (_) {
      return emit(BlDevicesBlocStateLoadFailure());
    }
  }

  Future<void> _mapLedStateRemovedFromGroupToState(
      BlDevicesBlocEventRemoveFromGroup event,
      Emitter<BlDevicesBlocState> emit) async {
    try {
      groupLedsStates.remove(event.ledState);
      _groupLedsStates.add(groupLedsStates);
      return emit(BlDevicesBlocStateLoadGroup(groupLedsStates.toList()));
    } catch (_) {
      return emit(BlDevicesBlocStateLoadFailure());
    }
  }

  Future<void> _mapLedStateAddedToIndependentState(
      BlDevicesBlocEventAddToIndependent event,
      Emitter<BlDevicesBlocState> emit) async {
    try {
      independentLedsStates.add(event.ledState);
      groupLedsStates.remove(event.ledState);
      notAssignedLedsStates.remove(event.ledState);
      _notAssignedLedsStates.add(notAssignedLedsStates);
      _independentLedsStates.add(independentLedsStates);
      _groupLedsStates.add(groupLedsStates);
      return emit(
          BlDevicesBlocStateLoadIndependent(independentLedsStates.toList()));
    } catch (_) {
      return emit(BlDevicesBlocStateLoadFailure());
    }
  }

  Future<void> _mapLedStateRemovedFromIndependentToState(
      BlDevicesBlocEventRemoveFromIndependent event,
      Emitter<BlDevicesBlocState> emit) async {
    try {
      independentLedsStates.remove(event.ledState);
      _independentLedsStates.add(independentLedsStates);
      return emit(
          BlDevicesBlocStateLoadIndependent(independentLedsStates.toList()));
    } catch (_) {
      return emit(BlDevicesBlocStateLoadFailure());
    }
  }

  void _mapLedStateAddedToNotAssignedToState(
      BlDevicesBlocEventAddToNotAssigned event,
      Emitter<BlDevicesBlocState> emit) {
    try {
      var logger = Logger();

      logger.d(event);
      logger.e(event.ledState);
      notAssignedLedsStates.add(event.ledState);
      independentLedsStates.remove(event.ledState);
      groupLedsStates.remove(event.ledState);
      _notAssignedLedsStates.add(notAssignedLedsStates);
      _independentLedsStates.add(independentLedsStates);
      _groupLedsStates.add(groupLedsStates);
      return emit(
          BlDevicesBlocStateLoadNotAssigned(notAssignedLedsStates.toList()));
    } catch (_) {
      return emit(BlDevicesBlocStateLoadFailure());
    }
  }

  Future<void> _mapLedStateRemovedFromNotAssignedToState(
      BlDevicesBlocEventRemoveFromNotAssigned event,
      Emitter<BlDevicesBlocState> emit) async {
    try {
      notAssignedLedsStates.remove(event.ledState);
      _notAssignedLedsStates.add(notAssignedLedsStates);
      return emit(
          BlDevicesBlocStateLoadNotAssigned(notAssignedLedsStates.toList()));
    } catch (_) {
      return emit(BlDevicesBlocStateLoadFailure());
    }
  }

  Future<void> _mapLedStateUpdateIndependent(
      BlDevicesBlocEventUpdateIndependent event,
      Emitter<BlDevicesBlocState> emit) async {
    try {
      for (final ledState in independentLedsStates) {
        if (ledState.name == event.ledState.name) {
          updateLeStateParam(event.ledState, ledState);
        }
      }
      _independentLedsStates.add(independentLedsStates);
      return emit(
          BlDevicesBlocStateUpdateIndependent(independentLedsStates.toList()));
    } catch (_) {
      return emit(BlDevicesBlocStateLoadFailure());
    }
  }

  Future<void> _mapLedStateUpdateGroup(BlDevicesBlocEventUpdateGroup event,
      Emitter<BlDevicesBlocState> emit) async {
    try {
      for (final ledState in groupLedsStates) {
        updateLeStateParam(event.ledState, ledState);
      }
      _groupLedsStates.add(groupLedsStates);
      return emit(BlDevicesBlocStateUpdateGroup(groupLedsStates.toList()));
    } catch (_) {
      return emit(BlDevicesBlocStateLoadFailure());
    }
  }

  Future<void> _mapLedStateConnect(
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
        return emit(BlDevicesBlocStateConnect(groupLedsStates.toList()));
      } else if (event.groupOrIndependent == GroupOrIndependent.independent) {
        return emit(BlDevicesBlocStateConnect(independentLedsStates.toList()));
      }
    } catch (_) {
      return emit(BlDevicesBlocStateLoadFailure());
    }
  }

  Future<void> _mapLedStateDisconnect(BlDevicesBlocEventDisconnect event,
      Emitter<BlDevicesBlocState> emit) async {
    try {
      //TODO implement removing ledState afetr disconnect
      await event.ledState.ledBluetoothDevice!.disconnect();
      if (event.groupOrIndependent == GroupOrIndependent.group) {
        // groupLedsStates.remove(event.ledState);
        // _groupLedsStates.add(groupLedsStates);
        // notAssignedLedsStates.add(event.ledState);
        // _notAssignedLedsStates.add(notAssignedLedsStates);
        return emit(BlDevicesBlocStateDisconnect(groupLedsStates.toList()));
      } else if (event.groupOrIndependent == GroupOrIndependent.independent) {
        // independentLedsStates.remove(event.ledState);
        // _independentLedsStates.add(independentLedsStates);
        // notAssignedLedsStates.add(event.ledState);
        // _notAssignedLedsStates.add(notAssignedLedsStates);
        return emit(
            BlDevicesBlocStateDisconnect(independentLedsStates.toList()));
      }
    } catch (_) {
      return emit(BlDevicesBlocStateLoadFailure());
    }
  }

  void updateLeStateParam(LedState eventLedState, LedState ledState) {
    var update = false;
    if (eventLedState.activeInIndependent != ledState.activeInIndependent &&
        eventLedState.state == States.active) {
      ledState.activeInIndependent = eventLedState.activeInIndependent;
      update = false;
    }
    if (eventLedState.characteristic != ledState.characteristic) {
      ledState.ledCharacteristic = eventLedState.characteristic;
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
