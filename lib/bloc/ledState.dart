import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';

enum States {
  empty,
  disabled,
  whiteRGB,
  whiteCool,
  whiteWarm,
  whiteCoolAndWarm,
  rgb,
  strobo,
  stroboStrongWhite,
  police,
  rgbFlare
}

class LedState {
  String name;
  Color color;
  BluetoothCharacteristic characteristic;
  States state;

  LedState(
      {String name,
      Color color,
      BluetoothCharacteristic characteristic,
      States state})
      : this.name = name ?? '',
        this.color = color ?? Color(0xFFFFFFFF),
        this.characteristic = characteristic ?? null,
        this.state = state ?? States.empty;

  @override
  bool operator ==(other) => other.name == this.name;

  @override
  int get hashCode => this.name.hashCode;

  Color get getColor => color;
  String get getName => name;
  BluetoothCharacteristic get getCharacteristic => characteristic;
  States get getState => state;

  set setColor(Color newColor) => this.color = newColor ?? Color(0xFFFFFFFF);

  set setName(String newName) => this.name = newName ?? '';

  set setState(States newState) => this.state = newState ?? States.empty;

  set setCharacteristic(BluetoothCharacteristic characteristic) {
    if (characteristic != null) {
      this.characteristic = characteristic;
    }
    print("characteristic == null"); //debug
  }

  @override
  String toString() {
    return 'LedState name: $name, color: $color, characteristic: $characteristic.';
  }
}
