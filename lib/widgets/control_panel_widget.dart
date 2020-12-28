import 'package:flutter/material.dart';
import 'package:rainbow_leds/bloc/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

class ControlPanelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: DefaultTabController(
          length: 2,
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
            body: TabBarView(physics: NeverScrollableScrollPhysics(), 
            children: [
              buildIndependentControler(context),
              buildGroupControler(context),
            ]),
          )),
    );
  }
}

Widget buildIndependentControler(BuildContext context) {
  return StreamBuilder(
      stream: BlocProvider.of<BlDevicesBlocBloc>(context).independentLedsStatesStream,
      initialData: {LedState(name: "EMPTY")},
      builder: (context, snapshot) =>
          buildIndependentControlPanel(snapshot.data, context));
}

Widget buildGroupControler(BuildContext context) {
  return StreamBuilder(
      stream: BlocProvider.of<BlDevicesBlocBloc>(context).groupLedsStatesStream,
      initialData: {LedState(name: "EMPTY")},
      builder: (context, snapshot) =>
          buildControlPanel(ledState: null, context: context));
}

Widget buildSidePanel(Set<LedState> ledStates, BuildContext context) {}

Widget buildIndependentControlPanel(Set<LedState> ledStates, BuildContext context) {
  // final MediaQueryData queryDat = MediaQuery.of(context);

  return buildControlPanel(ledState: ledStates.first, context: context);
}

Widget buildControlPanel({LedState ledState, BuildContext context}) {
  Color initialColor = Colors.amber;

  if (ledState != null) {
    initialColor = ledState.getColor;
  }
  print(initialColor);
  return Center(
    child: CircleColorPicker(
      initialColor: initialColor,
      size: const Size(340, 340),
      strokeWidth: 4,
      thumbSize: 36,
      colorCodeBuilder: (context, color) {
        return Text(
          'rgb(${color.red}, ${color.green}, ${color.blue})',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        );
      },
      onChanged: (value) {
        print("test");
        print(value);
        print("eeeeee");
        if (ledState == null) {
          BlocProvider.of<BlDevicesBlocBloc>(context).add(
              BlDevicesBlocEventUpdateGroup(LedState(color: value, state: States.rgb)));
        } else {
          BlocProvider.of<BlDevicesBlocBloc>(context).add(
              BlDevicesBlocEventUpdateIndependent(
                  LedState(name: ledState.name, color: value, state: States.rgb)));
        }
      },
    ),
  );
}
