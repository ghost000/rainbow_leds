import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../bl_manager/light_manager.dart';

enum LedStateEnum { group, notAssigned, independent }

enum States {
  empty,
  disable,
  whiteRGB,
  whiteRGBGradual,
  whiteCool,
  whiteCoolGradual,
  whiteWarm,
  whiteCoolAndWarm,
  whiteCoolAndWarmGradual,
  rgb,
  strobo,
  stroboStrongWhite,
  police,
  rgbFlare,
  disconnect,
  connect,
  active
}

class LedState {
  String name = "";
  String secondName = "";
  Color color = const Color(0xFF000000);
  States state = States.empty;
  LightManager lightManager = LightManager();
  int degree = 0;
  bool activeInIndependent = false;

  LedState(
      {String name = "",
      String secondName = "",
      Color color = const Color(0xFF000000),
      States state = States.empty,
      int degree = 0,
      bool active = false}) {
    name = name;
    secondName = secondName;
    color = color;
    degree = degree;
    state = state;
    activeInIndependent = active;
  }

  @override
  bool operator ==(dynamic other) =>
      other.ledName == name && other.color == color;

  @override
  int get hashCode => name.hashCode + color.hashCode;

  Color get ledColor => color;
  String get ledName => name;
  BluetoothCharacteristic? get ledCharacteristic =>
      lightManager.blCharacteristic;
  States get ledState => state;
  BluetoothDevice? get ledBluetoothDevice => lightManager.bluetoothDevice;
  int get ledDegree => degree;

  set ledColor(Color newColor) => color = newColor;

  set ledName(String newName) => name = newName;

  set ledState(States newState) => state = newState;

  set ledCharacteristic(BluetoothCharacteristic? characteristic) {
    lightManager.blCharacteristic = characteristic;
  }

  set ledBluetoothDevice(BluetoothDevice? bluetoothDevice) {
    lightManager.bluetoothDevice = bluetoothDevice;
  }

  void updateLightManager() {
    lightManager.changeStateAndUpdate(state, color, degree);
  }

  bool get getActive => activeInIndependent;

  void setActiveInIndependent() {
    activeInIndependent = true;
  }

  void setDeactivateInIndependent() {
    activeInIndependent = false;
  }

  @override
  String toString() {
    return 'LedState name: $name, color: $color, degree: $degree, lightManager: $lightManager.';
  }
}
