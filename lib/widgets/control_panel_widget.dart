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
      stream: BlocProvider.of<BlDevicesBlocBloc>(context).independentLedsStatesStream,
      initialData: {LedState(name: "EMPTY")},
      builder: (context, snapshot) => buildIndependentControlPanel(snapshot.data, context));
}

Widget buildGroupControler(BuildContext context) {
  return StreamBuilder(
      stream: BlocProvider.of<BlDevicesBlocBloc>(context).groupLedsStatesStream,
      initialData: {LedState(name: "EMPTY")},
      builder: (context, snapshot) => buildControlPanel(snapshot.data, context));
}

Widget buildSidePanel(Set<LedState> ledStates, BuildContext context) {}

Widget buildIndependentControlPanel(Set<LedState> ledStates, BuildContext context) {
 // final MediaQueryData queryDat = MediaQuery.of(context);

  return Center(
    child: CircleColorPicker(
      initialColor: Colors.white,
      size: const Size(240, 240),
      strokeWidth: 4,
      thumbSize: 36,
      onChanged: (value) {
        
      },
    ),
  );
}

Widget buildControlPanel(Set<LedState> ledStates, BuildContext context) {}
