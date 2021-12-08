import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart' show Rx;
import 'blocs.dart';

enum LedStateStream { both, independent, group, empty }

class DoubleStreamBuilder extends StatelessWidget {
  @override
  const DoubleStreamBuilder(
      {Key? key,
      required this.streamIndependent,
      required this.streamGroup,
      required this.builder})
      : super(key: key);

  final Stream<Set<LedState>> streamIndependent;
  final Stream<Set<LedState>> streamGroup;
  final Widget Function(BuildContext context, LedStateStream? snapshot) builder;

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: Rx.combineLatest2(streamIndependent, streamGroup,
          (Set<LedState> independent, Set<LedState> group) {
        if (independent.isNotEmpty && group.isNotEmpty) {
          return LedStateStream.both;
        }
        if (independent.isNotEmpty) {
          return LedStateStream.independent;
        }
        if (group.isNotEmpty) {
          return LedStateStream.group;
        }
        return LedStateStream.empty;
      }),
      builder: (context, AsyncSnapshot<LedStateStream> snapshot) =>
          builder(context, snapshot.data));
}
