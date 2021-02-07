import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_state_bloc_event.dart';
part 'app_state_bloc_state.dart';

class AppStateBlocBloc extends Bloc<AppStateBlocEvent, AppStateBlocState> {
  AppStateBlocBloc() : super(AppStateBlocInitial());

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
    } else if (event is AppStateBlocEventControlIndependentAndGroup) {
      yield AppStateBlocControlIndependentAndGroup();
    } else if (event is AppStateBlocEventControlIndependent) {
      yield AppStateBlocControlIndependent();
    } else if (event is AppStateBlocEventControlGroup) {
      yield AppStateBlocControlGroup();
    }
  }
}
