import 'package:rainbow_leds/bl_manager/light_manager.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';

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
  connect
}

class LedState {
  String name;
  Color color;
  States state;
  LightManager lightManager;
  int degree;

  LedState(
      {String name,
      Color color,
      BluetoothCharacteristic characteristic,
      States state,
      BluetoothDevice bluetoothDevice})
      : this.name = name ?? '',
        this.color = color ?? Color(0xFF000000),
        this.state = state ?? States.empty {
    this.lightManager = LightManager();
    this.lightManager.setCharacteristic = characteristic;
    this.lightManager.setBluetoothDevice = bluetoothDevice;
  }

  @override
  bool operator ==(other) =>
      other.name == this.name && other.color == this.color;

  @override
  int get hashCode => this.name.hashCode + this.color.hashCode;

  Color get getColor => color;
  String get getName => name;
  BluetoothCharacteristic get getCharacteristic =>
      lightManager.getCharacteristic;
  States get getState => state;
  BluetoothDevice get getBluetoothDevice => lightManager.getBluetoothDevice;
  int get getDegree => degree;

  set setColor(Color newColor) => this.color = newColor ?? Color(0xFFFFFFFF);

  set setName(String newName) => this.name = newName ?? '';

  set setState(States newState) => this.state = newState ?? States.empty;

  set setCharacteristic(BluetoothCharacteristic characteristic) {
    if (characteristic != null) {
      this.lightManager.setCharacteristic = characteristic;
    }
    print("characteristic == null"); //debug print
  }

  set setBluetoothDevice(BluetoothDevice bluetoothDevice) {
    if (bluetoothDevice != null) {
      this.lightManager.setBluetoothDevice = bluetoothDevice;
    }
    print("bluetoothDevice == null"); //debug print
  }

  set setDegree(int degree) => this.degree = degree;

  updateLightManager() {
    lightManager.changeStateAndUpdate(state, color, degree);
  }

  @override
  String toString() {
    return 'LedState name: $name, color: $color, degree: $degree, lightManager: $lightManager.';
  }
}
