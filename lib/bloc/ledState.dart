import 'package:equatable/equatable.dart';

class LedState extends Equatable {
  final String name;

  LedState(String name) : this.name = name ?? '';

  @override
  List<Object> get props => [name];

  @override
  String toString() {
    return 'LedState name: $name';
  }
}
