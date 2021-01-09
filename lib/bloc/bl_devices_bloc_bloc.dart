//import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:rainbow_leds/bloc/ledState.dart';
//import 'package:rainbow_leds/bl_manager/light_manager.dart';
import 'package:flutter_blue/flutter_blue.dart';

part 'bl_devices_bloc_event.dart';
part 'bl_devices_bloc_state.dart';

class Light {
  String transmitUuid = "f000aa61-0451-4000-b000-000000000000";

  Map<String, int> packetTypes = {
    'set_color': 0xa1,
    'set_white': 0xaa,
    'power_off': 0xa3,
  };
}

class BlDevicesBlocBloc extends Bloc<BlDevicesBlocEvent, BlDevicesBlocState> {
  BlDevicesBlocBloc() : super(BlDevicesBlocStateInitial()) {
    listenFlutterBlue();
  }

  String transmitUuid = "f000aa61-0451-4000-b000-000000000000";
  Set<LedState> groupLedsStates = {};
  Set<LedState> independentLedsStates = {};
  Set<LedState> notAssignedLedsStates = {};

  BehaviorSubject<Set<LedState>> _groupLedsStates = BehaviorSubject.seeded({});
  Stream<Set<LedState>> get groupLedsStatesStream => _groupLedsStates.stream;
  BehaviorSubject<Set<LedState>> _independentLedsStates =
      BehaviorSubject.seeded({});
  Stream<Set<LedState>> get independentLedsStatesStream =>
      _independentLedsStates.stream;
  BehaviorSubject<Set<LedState>> _notAssignedLedsStates =
      BehaviorSubject.seeded({});
  Stream<Set<LedState>> get notAssignedLedsStatesStream =>
      _notAssignedLedsStates.stream;

  listenFlutterBlue() async {
    FlutterBlue.instance.scanResults.listen((event) async {
      event.forEach((scanResult) async {
        if (scanResult.device.id.id != null &&
            scanResult.device.id.id.isNotEmpty &&
            scanResult.device.name.contains('YONGNUO')) {
          BluetoothCharacteristic characteristic;
          await scanResult.device.connect();
          await scanResult.device.discoverServices().then((value) {
            value.forEach((element) {
              element.characteristics.forEach((element) {
                if (element.uuid.toString() == transmitUuid) {
                  characteristic = element;
                  if (groupLedsStates
                          .where((element) =>
                              element.name == scanResult.device.id.id)
                          .isEmpty &&
                      independentLedsStates
                          .where((element) =>
                              element.name == scanResult.device.id.id)
                          .isEmpty &&
                      notAssignedLedsStates
                          .where((element) =>
                              element.name == scanResult.device.id.id)
                          .isEmpty) {
                    add(BlDevicesBlocEventAddToNotAssigned(LedState(
                        name: scanResult.device.id.id,
                        characteristic: characteristic,
                        bluetoothDevice: scanResult.device)));
                  }
                }
              });
            });
          });
        }
      });
    });
  }

  @override
  Future<void> close() {
    groupLedsStates.forEach((element) {
      element.setState = States.disconnect;
      element.updateLightManager();
    });
    independentLedsStates.forEach((element) {
      element.setState = States.disconnect;
      element.updateLightManager();
    });
    notAssignedLedsStates.forEach((element) {
      element.setState = States.disconnect;
      element.updateLightManager();
    });

    _groupLedsStates.close();
    _independentLedsStates.close();
    _notAssignedLedsStates.close();
    return super.close();
  }

  @override
  Stream<BlDevicesBlocState> mapEventToState(
    BlDevicesBlocEvent event,
  ) async* {
    if (event is BlDevicesBlocEventAddToGroup) {
      yield* _mapLedStateAddedToGroupToState(event);
    } else if (event is BlDevicesBlocEventRemoveFromGroup) {
      yield* _mapLedStateRemovedFromGroupToState(event);
    } else if (event is BlDevicesBlocEventAddToIndependent) {
      yield* _mapLedStateAddedToIndependentState(event);
    } else if (event is BlDevicesBlocEventRemoveFromIndependent) {
      yield* _mapLedStateRemovedFromIndependentToState(event);
    } else if (event is BlDevicesBlocEventAddToNotAssigned) {
      yield* _mapLedStateAddedToNotAssignedToState(event);
    } else if (event is BlDevicesBlocEventRemoveFromNotAssigned) {
      yield* _mapLedStateRemovedFromNotAssignedToState(event);
    } else if (event is BlDevicesBlocEventGetGroupLedsStates) {
      yield BlDevicesBlocStateGroup(groupLedsStates.toList());
    } else if (event is BlDevicesBlocEventGetIndependentLedsStates) {
      yield BlDevicesBlocStateIndependent(independentLedsStates.toList());
    } else if (event is BlDevicesBlocEventGetAllLedsStates) {
      yield BlDevicesBlocStateAll(groupLedsStates.toList(),
          independentLedsStates.toList(), notAssignedLedsStates.toList());
    } else if (event is BlDevicesBlocEventInitial) {
      yield BlDevicesBlocStateInitial();
    } else if (event is BlDevicesBlocEventScan) {
      yield BlDevicesBlocStateScan(); // add scaning in this state [FEATURE]
    } else if (event is BlDevicesBlocEventUpdateIndependent) {
      yield* _mapLedStateUpdateIndependent(event);
    } else if (event is BlDevicesBlocEventUpdateGroup) {
      yield* _mapLedStateUpdateGroup(event);
    }
  }

  Stream<BlDevicesBlocState> _mapLedStateAddedToGroupToState(
      BlDevicesBlocEventAddToGroup event) async* {
    try {
      groupLedsStates.add(event.ledState);
      notAssignedLedsStates.remove(event.ledState);
      independentLedsStates.remove(event.ledState);
      _notAssignedLedsStates.add(notAssignedLedsStates);
      _independentLedsStates.add(independentLedsStates);
      _groupLedsStates.add(groupLedsStates);
      yield BlDevicesBlocStateLoadGroup(groupLedsStates.toList());
    } catch (_) {
      yield BlDevicesBlocStateLoadFailure();
    }
  }

  Stream<BlDevicesBlocState> _mapLedStateRemovedFromGroupToState(
      BlDevicesBlocEventRemoveFromGroup event) async* {
    try {
      groupLedsStates.remove(event.ledState);
      _groupLedsStates.add(groupLedsStates);
      yield BlDevicesBlocStateLoadGroup(groupLedsStates.toList());
    } catch (_) {
      yield BlDevicesBlocStateLoadFailure();
    }
  }

  Stream<BlDevicesBlocState> _mapLedStateAddedToIndependentState(
      BlDevicesBlocEventAddToIndependent event) async* {
    try {
      independentLedsStates.add(event.ledState);
      groupLedsStates.remove(event.ledState);
      notAssignedLedsStates.remove(event.ledState);
      _notAssignedLedsStates.add(notAssignedLedsStates);
      _independentLedsStates.add(independentLedsStates);
      _groupLedsStates.add(groupLedsStates);
      yield BlDevicesBlocStateLoadIndependent(independentLedsStates.toList());
    } catch (_) {
      yield BlDevicesBlocStateLoadFailure();
    }
  }

  Stream<BlDevicesBlocState> _mapLedStateRemovedFromIndependentToState(
      BlDevicesBlocEventRemoveFromIndependent event) async* {
    try {
      independentLedsStates.remove(event.ledState);
      _independentLedsStates.add(independentLedsStates);
      yield BlDevicesBlocStateLoadIndependent(independentLedsStates.toList());
    } catch (_) {
      yield BlDevicesBlocStateLoadFailure();
    }
  }

  Stream<BlDevicesBlocState> _mapLedStateAddedToNotAssignedToState(
      BlDevicesBlocEventAddToNotAssigned event) async* {
    try {
      notAssignedLedsStates.add(event.ledState);
      independentLedsStates.remove(event.ledState);
      groupLedsStates.remove(event.ledState);
      _notAssignedLedsStates.add(notAssignedLedsStates);
      _independentLedsStates.add(independentLedsStates);
      _groupLedsStates.add(groupLedsStates);
      yield BlDevicesBlocStateLoadNotAssigned(notAssignedLedsStates.toList());
    } catch (_) {
      yield BlDevicesBlocStateLoadFailure();
    }
  }

  Stream<BlDevicesBlocState> _mapLedStateRemovedFromNotAssignedToState(
      BlDevicesBlocEventRemoveFromNotAssigned event) async* {
    try {
      notAssignedLedsStates.remove(event.ledState);
      _notAssignedLedsStates.add(notAssignedLedsStates);
      yield BlDevicesBlocStateLoadNotAssigned(notAssignedLedsStates.toList());
    } catch (_) {
      yield BlDevicesBlocStateLoadFailure();
    }
  }

  Stream<BlDevicesBlocState> _mapLedStateUpdateIndependent(
      BlDevicesBlocEventUpdateIndependent event) async* {
    try {
      independentLedsStates.forEach((ledState) {
        if (ledState.name == event.ledState.name) {
          updateLeStateParam(event.ledState, ledState);
        }
      });
      _independentLedsStates.add(independentLedsStates);
      yield BlDevicesBlocStateUpdateIndependent(independentLedsStates.toList());
    } catch (_) {
      yield BlDevicesBlocStateLoadFailure();
    }
  }

  Stream<BlDevicesBlocState> _mapLedStateUpdateGroup(
      BlDevicesBlocEventUpdateGroup event) async* {
    try {
      groupLedsStates.forEach((ledState) {
        updateLeStateParam(event.ledState, ledState);
      });
      _groupLedsStates.add(groupLedsStates);
      yield BlDevicesBlocStateUpdateGroup(groupLedsStates.toList());
    } catch (_) {
      yield BlDevicesBlocStateLoadFailure();
    }
  }

  void updateLeStateParam(LedState eventLedState, LedState ledState) {
    bool update = false;
    if (eventLedState.getCharacteristic != null &&
        eventLedState.getCharacteristic != ledState.getCharacteristic) {
      ledState.setCharacteristic = eventLedState.getCharacteristic;
    }
    if (eventLedState.color != null &&
        eventLedState.color != Color(0xFFFFFFFF) &&
        eventLedState.color != ledState.color) {
      ledState.setColor = eventLedState.color;
      update = true;
    }
    if (eventLedState.state != null &&
        eventLedState.state != States.empty &&
        eventLedState.state != ledState.state) {
      ledState.setState = eventLedState.state;
      update = true;
    }
    if (eventLedState.degree != null &&
        eventLedState.degree != ledState.degree) {
      ledState.degree = eventLedState.degree;
      update = true;
    }
    if (update) {
      ledState.updateLightManager();
    }
  }
}
