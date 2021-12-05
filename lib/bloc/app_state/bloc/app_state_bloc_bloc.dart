import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_state_bloc_event.dart';
part 'app_state_bloc_state.dart';

class AppStateBlocBloc extends Bloc<AppStateBlocEvent, AppStateBlocState> {
  AppStateBlocBloc() : super(AppStateBlocInitial()) {
    on<AppStateBlocEventInitial>((event, emit) {
      emit(AppStateBlocInitial());
    });
    on<AppStateBlocEventScan>((event, emit) {
      emit(AppStateBlocScan());
    });
    on<AppStateBlocEventBluetoothOff>((event, emit) {
      emit(AppStateBlocBluetoothOff());
    });
    on<AppStateBlocEventGroup>((event, emit) {
      emit(AppStateBlocGroup());
    });
    on<AppStateBlocEventControlIndependentAndGroup>((event, emit) {
      emit(AppStateBlocControlIndependentAndGroup());
    });
    on<AppStateBlocEventControlIndependent>((event, emit) {
      emit(AppStateBlocControlIndependent());
    });
    on<AppStateBlocEventControlGroup>((event, emit) {
      emit(AppStateBlocControlGroup());
    });
    on<AppStateBlocEventScenario>((event, emit) {
      emit(AppStateBlocScenario());
    });
  }
}
