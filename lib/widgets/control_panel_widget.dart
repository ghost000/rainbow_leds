import 'package:flutter/material.dart';
import 'package:rainbow_leds/bloc/blocs.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:rainbow_leds/widgets/bluetooth_off_screen.dart';

class ControlPanelScreen extends StatefulWidget {
  final _ControlPanelScreenState state = _ControlPanelScreenState();

  @override
  _ControlPanelScreenState createState() => state;
}

class _ControlPanelScreenState extends State<ControlPanelScreen> {
  Color _groupInitialColor = Colors.amber;
  Color _independentInitialColor = Colors.blue;
  LedState _ledState;
  int _value;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (context, snapshot) {
          if (snapshot.data != BluetoothState.on) {
            return BluetoothOffScreen(state: snapshot.data);
          }
          return WillPopScope(
            onWillPop: () {
              BlocProvider.of<AppStateBlocBloc>(context).add(AppStateBlocEventGroup());

              Navigator.of(context).pop();
              return Future.value(true);
            },
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: AppBar(
                      bottom: PreferredSize(
                        preferredSize: new Size(0.0, 20.0),
                        child: TabBar(
                          tabs: [
                            Tab(
                              icon: Icon(Icons.format_italic),
                            ),
                            Tab(
                              icon: Icon(Icons.format_list_numbered),
                            )
                          ],
                        ),
                      ),
                      title: Text("Control Panel"),
                    ),
                    body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
                      buildIndependentControler(context),
                      buildGroupControler(context),
                    ]),
                  )),
            ),
          );
        });
  }

  Widget buildIndependentControler(BuildContext context) {
    return StreamBuilder(
        stream: BlocProvider.of<BlDevicesBlocBloc>(context).independentLedsStatesStream,
        initialData: BlocProvider.of<BlDevicesBlocBloc>(context).independentLedsStates,
        builder: (context, snapshot) {
          return ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              buildIndependentControlPanel(snapshot.data, context),
              buildButtons(snapshot.data, LedStateEnum.independent, context)
            ],
          );
        });
  }

  Widget buildIndependentControlPanel(Set<LedState> ledStates, BuildContext context) {
    return buildIndependentColorPanel(ledState: ledStates.first, context: context);
  }

  Widget buildIndependentColorPanel({LedState ledState, BuildContext context}) {
    _ledState = ledState;
    _independentInitialColor = ledState.color;
    return Center(
        child: Align(
            alignment: Alignment.topCenter,
            child: CircleColorPicker(
              initialColor: _independentInitialColor,
              size: Size(MediaQuery.of(context).size.height / 2.25,
                  MediaQuery.of(context).size.height / 2.25),
              strokeWidth: 5,
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
              onChanged: _onIndependentColorChanged,
            )));
  }

  void _onIndependentColorChanged(Color color) {
    setState(() => _independentInitialColor = color);
    BlocProvider.of<BlDevicesBlocBloc>(context).add(BlDevicesBlocEventUpdateIndependent(
        LedState(name: _ledState.name, color: color, state: States.rgb)));
  }

  Widget buildGroupControler(BuildContext context) {
    return StreamBuilder(
        stream: BlocProvider.of<BlDevicesBlocBloc>(context).groupLedsStatesStream,
        initialData: BlocProvider.of<BlDevicesBlocBloc>(context).groupLedsStates,
        builder: (context, snapshot) => buildGroupColorPanel(context));
  }

  Widget buildGroupColorPanel(BuildContext context) {
    return Center(
        child: Align(
      alignment: Alignment.topCenter,
      heightFactor: 1.8,
      child: CircleColorPicker(
        initialColor: _groupInitialColor,
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
        onChanged: _onGroupColorChanged,
      ),
    ));
  }

  void _onGroupColorChanged(Color color) {
    setState(() => _groupInitialColor = color);
    BlocProvider.of<BlDevicesBlocBloc>(context)
        .add(BlDevicesBlocEventUpdateGroup(LedState(color: color, state: States.rgb)));
  }

  Widget buildButtons(
      Set<LedState> ledStates, LedStateEnum ledStateEnum, BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white70,
              trackShape: RoundedRectSliderTrackShape(),
              trackHeight: 4.0,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
              thumbColor: Colors.yellowAccent,
              overlayColor: Colors.yellow.withAlpha(32),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              tickMarkShape: RoundSliderTickMarkShape(),
              activeTickMarkColor: Colors.white,
              inactiveTickMarkColor: Colors.black,
              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
              valueIndicatorColor: Colors.white,
              valueIndicatorTextStyle: TextStyle(
                color: Colors.black,
              ),
            ),
            child: Slider(
              value: _value?.toDouble() ?? 0,
              min: 0,
              max: 100,
              divisions: 100,
              label: '$_value',
              onChanged: (value) {
                setState(
                  () {
                    _value = value.toInt();
                  },
                );
              },
            ),
          ),
          Divider(color: Colors.transparent),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton(ledStates.first, ledStateEnum, context, 3, Colors.white,
                  Colors.black, "test", Colors.white, print),
              buildButton(ledStates.first, ledStateEnum, context, 3, Colors.white,
                  Colors.black, "test", Colors.white, print),
              buildButton(ledStates.first, ledStateEnum, context, 3, Colors.white,
                  Colors.black, "test", Colors.white, print),
            ],
          ),
          Divider(color: Colors.transparent),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton(ledStates.first, ledStateEnum, context, 3, Colors.white,
                  Colors.black, "test", Colors.white, print),
              buildButton(ledStates.first, ledStateEnum, context, 3, Colors.white,
                  Colors.black, "test", Colors.white, print),
              buildButton(ledStates.first, ledStateEnum, context, 3, Colors.white,
                  Colors.black, "test", Colors.white, print),
            ],
          ),
          Divider(color: Colors.transparent),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton(ledStates.first, ledStateEnum, context, 3, Colors.white,
                  Colors.black, "test", Colors.white, print),
              buildButton(ledStates.first, ledStateEnum, context, 3, Colors.white,
                  Colors.black, "test", Colors.white, print),
              buildButton(ledStates.first, ledStateEnum, context, 3, Colors.white,
                  Colors.black, "test", Colors.white, print),
            ],
          ),
          Divider(color: Colors.transparent),
        ]));
  }

  Widget buildButton(
      LedState ledStates,
      LedStateEnum ledStateEnum,
      BuildContext context,
      int countButtonInRow,
      Color leftGradienColor,
      Color rightGradienColor,
      String buttonName,
      Color buttonTextColor,
      void Function(Object object) onTap) {
    return Container(
        child: GestureDetector(
      onTap: () {
        onTap?.call("test");
        //add functions of this button here
        // BlocProvider.of<BlDevicesBlocBloc>(context)
        //     .add(BlDevicesBlocEventAddToIndependent(LedState(
        //   name: ledStates.name,
        // )));
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 17,
        width: MediaQuery.of(context).size.width / (countButtonInRow + 0.3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft, // / countButtonInRow.toDouble(),
            end: Alignment.centerRight, // countButtonInRow.toDouble(),
            colors: [leftGradienColor, rightGradienColor],
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Center(
          child: Text(
            buttonName,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: buttonTextColor, fontSize: 18.0),
          ),
        ),
      ),
    ));
  }

  //   Align(
  //     child: FlatButton(
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10.0),
  //           side: BorderSide(color: Colors.cyan)),
  //       color: Colors.cyanAccent,
  //       onPressed: () {
  //         BlocProvider.of<BlDevicesBlocBloc>(context).add(
  //             BlDevicesBlocEventAddToIndependent(LedState(
  //                 name: ledStates.name,)));
  //       },
  //       child: Text("ADD independent"),
  //     ),
  //     alignment: Alignment.centerRight,
  //   );
  // }

  // Widget buildSidePanel(Set<LedState> ledStates, BuildContext context) {}

}
