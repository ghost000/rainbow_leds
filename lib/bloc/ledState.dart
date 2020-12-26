//import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

typedef Color MaterialColor();

class LedState{//} extends Equatable {
  final String name;
  Color color;

  LedState({String name, Color color})
      : this.name = name ?? '',
        this.color = color ?? Color(0xFFFFFFFF);

  void changeColor(Color newColor) {
    this.color = newColor;
  }

  // @override
  // List<Object> get props => [name];

  @override
  String toString() {
    return 'LedState name: $name';
  }
}
