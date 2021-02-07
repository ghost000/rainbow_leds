part of 'app_state_bloc_bloc.dart';

abstract class AppStateBlocEvent extends Equatable {
  const AppStateBlocEvent();

  @override
  List<Object> get props => [];
}

class AppStateBlocEventInitial extends AppStateBlocEvent {
  @override
  String toString() {
    return 'AppStateBlocEventInitial';
  }
}

class AppStateBlocEventScan extends AppStateBlocEvent {
  @override
  String toString() {
    return 'AppStateBlocEventScan';
  }
}

class AppStateBlocEventBluetoothOff extends AppStateBlocEvent {
  @override
  String toString() {
    return 'AppStateBlocEventBluetoothOff';
  }
}

class AppStateBlocEventGroup extends AppStateBlocEvent {
  @override
  String toString() {
    return 'AppStateBlocEventGroup';
  }
}

class AppStateBlocEventControlIndependentAndGroup extends AppStateBlocEvent {
  @override
  String toString() {
    return 'AppStateBlocEventControlIndependentAndGroup';
  }
}

class AppStateBlocEventControlIndependent extends AppStateBlocEvent {
  @override
  String toString() {
    return 'AppStateBlocEventControlIndependent';
  }
}

class AppStateBlocEventControlGroup extends AppStateBlocEvent {
  @override
  String toString() {
    return 'AppStateBlocEventControlGroup';
  }
}

class AppStateBlocEventScenario extends AppStateBlocEvent {
  @override
  String toString() {
    return 'AppStateBlocEventScenario';
  }
}
