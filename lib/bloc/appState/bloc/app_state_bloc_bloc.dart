import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_blue/flutter_blue.dart';

part 'app_state_bloc_event.dart';
part 'app_state_bloc_state.dart';

class AppStateBlocBloc extends Bloc<AppStateBlocEvent, AppStateBlocState> {
  AppStateBlocBloc() : super(AppStateBlocInitial()) {
    listenFlutterBlue();
  }

  listenFlutterBlue() {
    FlutterBlue.instance.state.listen((event) {
      if (event == BluetoothState.on) {
        add(AppStateBlocEventGroup());
      } else {
        add(AppStateBlocEventBluetoothOff());
      }
    });
  }

  @override
  Stream<AppStateBlocState> mapEventToState(
    AppStateBlocEvent event,
  ) async* {
    if (event is AppStateBlocEventInitial) {
      yield AppStateBlocInitial();
    } else if (event is AppStateBlocEventScan) {
      yield AppStateBlocScan();
    } else if (event is AppStateBlocEventBluetoothOff) {
      yield AppStateBlocBluetoothOff();
    } else if (event is AppStateBlocEventGroup) {
      yield AppStateBlocGroup();
    } else if (event is AppStateBlocEventControl) {
      yield AppStateBlocControl();
    }
  }
}
