import 'package:rainbow_leds/bl_manager/light_manager.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';

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
    lightManager.setCharacteristic = characteristic;
    lightManager.setBluetoothDevice = bluetoothDevice;
  }

  @override
  bool operator ==(dynamic other) => other.name == name && other.color == color;

  @override
  int get hashCode => name.hashCode + color.hashCode;

  Color get getColor => color;
  String get getName => name;
  BluetoothCharacteristic get getCharacteristic =>
      lightManager.getCharacteristic;
  States get getState => state;
  BluetoothDevice get getBluetoothDevice => lightManager.getBluetoothDevice;
  int get getDegree => degree;

  set setColor(Color newColor) => color = newColor ?? const Color(0xFFFFFFFF);

  set setName(String newName) => name = newName ?? '';

  set setState(States newState) => state = newState ?? States.empty;

  set setCharacteristic(BluetoothCharacteristic characteristic) {
    if (characteristic != null) {
      lightManager.setCharacteristic = characteristic;
    }
    print("characteristic == null"); //debug print
  }

  set setBluetoothDevice(BluetoothDevice bluetoothDevice) {
    if (bluetoothDevice != null) {
      lightManager.setBluetoothDevice = bluetoothDevice;
    }
    print("bluetoothDevice == null"); //debug print
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
