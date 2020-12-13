import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rainbow_leds/bloc/ledState.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rxdart/rxdart.dart';

part 'bl_devices_bloc_event.dart';
part 'bl_devices_bloc_state.dart';

class BlDevicesBlocBloc extends Bloc<BlDevicesBlocEvent, BlDevicesBlocState> {
  BlDevicesBlocBloc() : super(BlDevicesBlocStateInitial()) {
    listenFlutterBlue();
  }

  Set<LedState> groupLedsStates = {};
  Set<LedState> independentLedsStates = {};
  Set<LedState> notAssignedLedsStates = {};

  BehaviorSubject<Set<LedState>> _groupLedsStates = BehaviorSubject.seeded({});
  Stream<Set<LedState>> get groupLedsStatesStream => _groupLedsStates.stream;
  BehaviorSubject<Set<LedState>> _independentLedsStates = BehaviorSubject.seeded({});
  Stream<Set<LedState>> get independentLedsStatesStream => _independentLedsStates.stream;
  BehaviorSubject<Set<LedState>> _notAssignedLedsStates = BehaviorSubject.seeded({});
  Stream<Set<LedState>> get notAssignedLedsStatesStream => _notAssignedLedsStates.stream;

  listenFlutterBlue() {
    FlutterBlue.instance.scanResults.listen((event) {
      event.forEach((scanResult) {
        if (scanResult.device.name != null && scanResult.device.name.isNotEmpty) {
          if (groupLedsStates
                  .where((element) => element.name == scanResult.device.name)
                  .isEmpty &&
              independentLedsStates
                  .where((element) => element.name == scanResult.device.name)
                  .isEmpty) {
            add(BlDevicesBlocEventAddToNotAssigned(LedState(scanResult.device.name)));
          }
        }
      });
    });
  }

  @override
  Future<void> close() {
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
    }
  }

  Stream<BlDevicesBlocState> _mapLedStateAddedToGroupToState(
      BlDevicesBlocEventAddToGroup event) async* {
    try {
      notAssignedLedsStates.remove(event.ledState);
      independentLedsStates.remove(event.ledState);
      groupLedsStates.add(event.ledState);
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
      groupLedsStates.remove(event.ledState);
      notAssignedLedsStates.remove(event.ledState);
      independentLedsStates.add(event.ledState);
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
      independentLedsStates.remove(event.ledState);
      groupLedsStates.remove(event.ledState);
      notAssignedLedsStates.add(event.ledState);
      _notAssignedLedsStates.add(notAssignedLedsStates);
      _independentLedsStates.add(independentLedsStates);
      _groupLedsStates.add(groupLedsStates);
      print(independentLedsStates);
      print(groupLedsStates);
      print(notAssignedLedsStates);

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
}
