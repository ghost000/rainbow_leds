import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';

class LedState extends Equatable {
  final String name;
  final Color

  LedState(String name) : this.name = name ?? '';

  @override
  List<Object> get props => [name];

  @override
  String toString() {
    return 'LedState name: $name';
  }
}
