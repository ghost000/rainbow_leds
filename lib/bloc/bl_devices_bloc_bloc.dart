import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rainbow_leds/bloc/ledState.dart';
import 'ledState.dart';

part 'bl_devices_bloc_event.dart';
part 'bl_devices_bloc_state.dart';

class BlDevicesBlocBloc extends Bloc<BlDevicesBlocEvent, BlDevicesBlocState> {
  BlDevicesBlocBloc() : super(BlDevicesBlocInitial());

  @override
  Stream<BlDevicesBlocState> mapEventToState(
    BlDevicesBlocEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
