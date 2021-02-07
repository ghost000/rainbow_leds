part of 'app_state_bloc_bloc.dart';

abstract class AppStateBlocState extends Equatable {
  const AppStateBlocState();

  @override
  List<Object> get props => [];
}

class AppStateBlocInitial extends AppStateBlocState {}

class AppStateBlocScan extends AppStateBlocState {}

class AppStateBlocBluetoothOff extends AppStateBlocState {}

class AppStateBlocGroup extends AppStateBlocState {}

class AppStateBlocControlIndependentAndGroup extends AppStateBlocState {}

class AppStateBlocControlIndependent extends AppStateBlocState {}

class AppStateBlocControlGroup extends AppStateBlocState {}
