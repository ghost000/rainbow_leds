import 'package:flutter/material.dart';
import 'package:rainbow_leds/bloc/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

class ControlPanelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.format_italic),
                ),
                Tab(
                  icon: Icon(Icons.format_list_numbered),
                )
              ],
            ),
            title: Text("Control Panel"),
          ),
          body: TabBarView(children: [
            buildIndependentControler(context),
            buildGroupControler(context),
          ]),
        ));
  }
}

Widget buildIndependentControler(BuildContext context) {
  return StreamBuilder(
      stream: BlocProvider.of<BlDevicesBlocBloc>(context)
          .independentLedsStatesStream,
      initialData: {LedState("EMPTY")},
      builder: (context, snapshot) => snapshot.data.map((ledState) {
            return Text(ledState.name.toString());
          }).toList());
}

Widget buildGroupControler(BuildContext context) {
  return StreamBuilder(
      stream: BlocProvider.of<BlDevicesBlocBloc>(context).groupLedsStatesStream,
      initialData: {LedState("EMPTY")},
      builder: (context, snapshot) {
        snapshot.data.map((ledState) {
          return Text(ledState.name.toString());
        }).toList();
      });
}
