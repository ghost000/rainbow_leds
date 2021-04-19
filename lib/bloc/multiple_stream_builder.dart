import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rainbow_leds/bloc/blocs.dart';

enum LedStateStream { both, independent, group, empty }

class DoubleStreamBuilder extends StatelessWidget {
  @override
  const DoubleStreamBuilder(
      {@required this.streamIndependent,
      @required this.streamGroup,
      @required this.builder});

  final Stream<Set<LedState>> streamIndependent;
  final Stream<Set<LedState>> streamGroup;
  final Widget Function(BuildContext context, LedStateStream snapshot) builder;

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: Rx.combineLatest2(streamIndependent, streamGroup,
          (Set<LedState> independent, Set<LedState> group) {
        if (independent != null || group != null) {
          if (independent.isNotEmpty && group.isNotEmpty) {
            return LedStateStream.both;
          }
          if (independent != null) {
            if (independent.isNotEmpty) {
              return LedStateStream.independent;
            }
          }
          if (group != null) {
            if (group.isNotEmpty) {
              return LedStateStream.group;
            }
          }
        }
        return LedStateStream.empty;
      }),
      builder: (BuildContext context, AsyncSnapshot<LedStateStream> snapshot) =>
          builder(context, snapshot.data));
}
