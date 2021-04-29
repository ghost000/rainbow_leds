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
  String name;
  Color color;
  States state;
  LightManager lightManager;
  int degree;
  bool activeInIndependent;

  LedState(
      {String name,
      Color color,
      BluetoothCharacteristic characteristic,
      States state,
      int degree,
      BluetoothDevice bluetoothDevice,
      bool active})
      : name = name ?? '',
        color = color ?? const Color(0xFF000000),
        degree = degree ?? 0,
        state = state ?? States.empty,
        activeInIndependent = active ?? false {
    lightManager = LightManager(characteristic, bluetoothDevice);
    lightManager.characteristic = characteristic;
    lightManager.bluetoothDevice = bluetoothDevice;
  }

  @override
  bool operator ==(dynamic other) =>
      other.ledName == name && other.color == color;

  @override
  int get hashCode => name.hashCode + color.hashCode;

  Color get ledColor => color;
  String get ledName => name;
  BluetoothCharacteristic get ledCharacteristic => lightManager.characteristic;
  States get ledState => state;
  BluetoothDevice get ledBluetoothDevice => lightManager.bluetoothDevice;
  int get ledDegree => degree;

  set ledColor(Color newColor) => color = newColor ?? const Color(0xFFFFFFFF);

  set ledName(String newName) => name = newName ?? '';

  set ledState(States newState) => state = newState ?? States.empty;

  set ledCharacteristic(BluetoothCharacteristic characteristic) {
    if (characteristic != null) {
      lightManager.characteristic = characteristic;
    }
  }

  set ledBluetoothDevice(BluetoothDevice bluetoothDevice) {
    if (bluetoothDevice != null) {
      lightManager.bluetoothDevice = bluetoothDevice;
    }
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
