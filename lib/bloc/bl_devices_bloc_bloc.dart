import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rainbow_leds/bloc/ledState.dart';

part 'bl_devices_bloc_event.dart';
part 'bl_devices_bloc_state.dart';

class BlDevicesBlocBloc extends Bloc<BlDevicesBlocEvent, BlDevicesBlocState> {
  BlDevicesBlocBloc() : super(BlDevicesBlocStateInitial());
  Set<LedState> groupLedsStates = {};
  Set<LedState> independentLedsStates = {};
  Set<LedState> notAssignedLedsStates = {};

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
      yield BlDevicesBlocStateLoadGroup(groupLedsStates.toList());
    } catch (_) {
      yield BlDevicesBlocStateLoadFailure();
    }
  }

  Stream<BlDevicesBlocState> _mapLedStateRemovedFromGroupToState(
      BlDevicesBlocEventRemoveFromGroup event) async* {
    try {
      groupLedsStates.remove(event.ledState);
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
      yield BlDevicesBlocStateLoadIndependent(independentLedsStates.toList());
    } catch (_) {
      yield BlDevicesBlocStateLoadFailure();
    }
  }

  Stream<BlDevicesBlocState> _mapLedStateRemovedFromIndependentToState(
      BlDevicesBlocEventRemoveFromIndependent event) async* {
    try {
      independentLedsStates.remove(event.ledState);
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
      yield BlDevicesBlocStateLoadNotAssigned(notAssignedLedsStates.toList());
    } catch (_) {
      yield BlDevicesBlocStateLoadFailure();
    }
  }
}
