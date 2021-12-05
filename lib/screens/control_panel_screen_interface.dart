import 'package:flutter/material.dart';
import 'package:rainbow_leds/bloc/blocs.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rainbow_leds/screens/bluetooth_off_screen.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

class ControlPanelScreenInterface extends StatefulWidget {
  const ControlPanelScreenInterface({Key? key}) : super(key: key);
  @override
  ControlPanelScreenInterfaceState createState() =>
      ControlPanelScreenInterfaceState();
}

class ControlPanelScreenInterfaceState<T extends ControlPanelScreenInterface>
    extends State<T> {
  String titleName = 'Control Panel.';
  int value = 0;
  States stateForWhite = States.empty;
  LedStateEnum ledStateEnum = LedStateEnum.independent;
  int selectedIndexIndependent = 0;
  int selectedIndexGroup = 0;
  bool testIndependentFlag = false;
  bool testGroupFlag = false;
  Color groupInitialColor = Colors.amber;
  late LedState ledState;

  late CircleColorPickerController circleColorPickerController;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget buildClassWidget(BuildContext context) {
    return Container();
  }

  Widget buildWidget(BuildContext context) {
    return BlocListener<AppStateBlocBloc, AppStateBlocState>(
        bloc: BlocProvider.of<AppStateBlocBloc>(context),
        listener: (context, state) {
          if (state is AppStateBlocScenario) {
            Navigator.of(context).pushNamed('/ScenarioSetterScreen');
          }
        },
        child: StreamBuilder<BluetoothState>(
            stream: FlutterBlue.instance.state,
            initialData: BluetoothState.unknown,
            builder: (context, snapshot) {
              if (snapshot.data != BluetoothState.on) {
                return BluetoothOffScreen(state: snapshot.data);
              }
              return WillPopScope(
                  onWillPop: () {
                    BlocProvider.of<AppStateBlocBloc>(context)
                        .add(AppStateBlocEventGroup());
                    Navigator.of(context).pop();
                    return Future.value(true);
                  },
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      child: buildClassWidget(context)));
            }));
  }

  void setTitleNameAfterBuildIndependent() {
    setState(() {
      testIndependentFlag = true;
      titleName = 'Control Panel. \n Selescted led: ${ledState.ledName}';
    });
  }

  void setTitleNameAfterBuildGroup() {
    setState(() {
      testGroupFlag = true;
      titleName = 'Control Panel. Group leds';
    });
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white10,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.palette_outlined),
          label: 'RGB',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.wb_sunny_outlined),
          label: 'White',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.grade_outlined),
          label: 'Scenario',
        ),
      ],
      currentIndex: ledStateEnum == LedStateEnum.independent
          ? selectedIndexIndependent
          : selectedIndexGroup,
      selectedItemColor: Colors.amber[800],
      onTap: (int index) {
        setState(() {
          ledStateEnum == LedStateEnum.independent
              ? selectedIndexIndependent = index
              : selectedIndexGroup = index;
        });
      },
      iconSize: 27,
      selectedFontSize: 17,
      unselectedFontSize: 15,
    );
  }

  Widget buildIndependentControler(BuildContext context) {
    return StreamBuilder(
        stream: BlocProvider.of<BlDevicesBlocBloc>(context)
            .independentLedsStatesStream,
        initialData:
            BlocProvider.of<BlDevicesBlocBloc>(context).independentLedsStates,
        builder: (context, AsyncSnapshot<Set<LedState>> snapshot) {
          getActiveLedOrCheckFirst(snapshot.data);
          addPostBuildCallbackToSetSelectedOrFirstLedName();
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              if (selectedIndexIndependent == 0) buildColorPanel(context),
              if (selectedIndexIndependent == 1) buildButtonsWhite(context),
              if (selectedIndexIndependent == 2) buildScenarioButtons(),
            ],
          );
        });
  }

  void getActiveLedOrCheckFirst(Set<LedState>? ledStates) {
    for (final _ledState in ledStates!) {
      if (_ledState.activeInIndependent) {
        ledState = _ledState;
        return;
      }
    }
    ledState = ledStates.first;
    ledState.setActiveInIndependent();
    BlocProvider.of<BlDevicesBlocBloc>(context).add(
        BlDevicesBlocEventUpdateIndependent(
            ledState: LedState(
                name: ledState.name, active: ledState.activeInIndependent)));
  }

  void addPostBuildCallbackToSetSelectedOrFirstLedName() {
    if (!testIndependentFlag && ledState.name.isNotEmpty) {
      WidgetsBinding.instance!
          .addPostFrameCallback((_) => setTitleNameAfterBuildIndependent());
    }
  }

  void _onIndependentColorChanged(Color color) {
    setState(() => ledState.color = color);
    BlocProvider.of<BlDevicesBlocBloc>(context).add(
        BlDevicesBlocEventUpdateIndependent(
            ledState: LedState(
                name: ledState.name, color: color, state: States.rgb)));
  }

  Widget buildGroupControler(BuildContext context) {
    if (!testGroupFlag) {
      WidgetsBinding.instance!
          .addPostFrameCallback((_) => setTitleNameAfterBuildGroup());
    }
    return StreamBuilder(
        stream:
            BlocProvider.of<BlDevicesBlocBloc>(context).groupLedsStatesStream,
        initialData:
            BlocProvider.of<BlDevicesBlocBloc>(context).groupLedsStates,
        builder: (context, AsyncSnapshot<Set<LedState>> snapshot) {
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              if (selectedIndexGroup == 0) buildColorPanel(context),
              if (selectedIndexGroup == 1) buildButtonsWhite(context),
              if (selectedIndexGroup == 2) buildScenarioButtons(),
            ],
          );
        });
  }

  Widget buildColorPanel(BuildContext context) {
    circleColorPickerController = CircleColorPickerController(
      initialColor: ledStateEnum == LedStateEnum.independent
          ? ledState.color
          : groupInitialColor,
    );
    return Center(
        child: Align(
            child: Column(children: [
      Divider(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height / 20),
      CircleColorPicker(
        controller: circleColorPickerController,
        size: Size(MediaQuery.of(context).size.height / 2.3,
            MediaQuery.of(context).size.height / 2.3),
        strokeWidth: 5,
        thumbSize: 36,
        colorCodeBuilder: (context, color) {
          return Text(
            'rgb(${color.red}, ${color.green}, ${color.blue})',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          );
        },
        onChanged: ledStateEnum == LedStateEnum.independent
            ? _onIndependentColorChanged
            : _onGroupColorChanged,
      ),
    ])));
  }

  void _onGroupColorChanged(Color color) {
    setState(() => groupInitialColor = color);
    BlocProvider.of<BlDevicesBlocBloc>(context).add(
        BlDevicesBlocEventUpdateGroup(
            ledState: LedState(color: color, state: States.rgb)));
  }

  void whiteUpdate() {
    if (stateForWhite == States.whiteCoolGradual ||
        stateForWhite == States.whiteRGBGradual ||
        stateForWhite == States.whiteCoolAndWarmGradual) {
      if (ledStateEnum == LedStateEnum.independent) {
        BlocProvider.of<BlDevicesBlocBloc>(context).add(
            BlDevicesBlocEventUpdateIndependent(
                ledState: LedState(
                    name: ledState.ledName,
                    state: stateForWhite,
                    degree: value)));
      } else if (ledStateEnum == LedStateEnum.group) {
        BlocProvider.of<BlDevicesBlocBloc>(context).add(
            BlDevicesBlocEventUpdateGroup(
                ledState: LedState(state: stateForWhite, degree: value)));
      }
    }
  }

  Widget buildButtonsWhite(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Divider(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height / 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white70,
              trackShape: const RoundedRectSliderTrackShape(),
              trackHeight: 10.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
              thumbColor: Colors.yellowAccent,
              overlayColor: Colors.yellow.withAlpha(32),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
              tickMarkShape: const RoundSliderTickMarkShape(),
              activeTickMarkColor: Colors.white,
              inactiveTickMarkColor: Colors.black,
              valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
              valueIndicatorColor: Colors.white,
              valueIndicatorTextStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
            child: Slider(
              value: value.toDouble(),
              max: 99,
              divisions: 99,
              label: '$value',
              onChanged: (_value) {
                setState(
                  () {
                    value = _value.toInt();
                    whiteUpdate();
                  },
                );
              },
            ),
          ),
          Divider(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height / 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton(
                  context: context,
                  state: States.whiteRGBGradual,
                  degree: 0,
                  countButtonInRow: 3,
                  leftGradienColor: Colors.white,
                  rightGradienColor: Colors.white,
                  buttonName: 'white rgb',
                  buttonTextColor: Colors.black),
              buildButton(
                  context: context,
                  state: States.whiteCoolGradual,
                  degree: 0,
                  countButtonInRow: 3,
                  leftGradienColor: Colors.white,
                  rightGradienColor: Colors.white,
                  buttonName: 'white cool',
                  buttonTextColor: Colors.black),
              buildButton(
                  context: context,
                  state: States.whiteCoolAndWarmGradual,
                  degree: 0,
                  countButtonInRow: 3,
                  leftGradienColor: Colors.white,
                  rightGradienColor: Colors.white,
                  buttonName: 'white rgb+cool',
                  buttonTextColor: Colors.black),
            ],
          ),
          Divider(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height / 30),
        ]));
  }

  Widget buildScenarioButtons() {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Divider(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height / 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildButton(
                  context: context,
                  state: States.strobo,
                  degree: 0,
                  countButtonInRow: 3,
                  leftGradienColor: Colors.white,
                  rightGradienColor: Colors.black,
                  buttonName: 'strobo rgb',
                  buttonTextColor: Colors.white),
              buildButton(
                  context: context,
                  state: States.stroboStrongWhite,
                  degree: 0,
                  countButtonInRow: 3,
                  leftGradienColor: Colors.white,
                  rightGradienColor: Colors.black,
                  buttonName: 'strobo cool',
                  buttonTextColor: Colors.white),
            ],
          ),
          Divider(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height / 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: buildButtonRowDependentOnLedState().toList(),
          ),
          const Divider(color: Colors.transparent),
        ]));
  }

  List<Widget> buildButtonRowDependentOnLedState() {
    return <Widget>[
      buildButton(
          context: context,
          state: States.rgbFlare,
          degree: 0,
          countButtonInRow: 3,
          leftGradienColor: Colors.deepPurpleAccent,
          rightGradienColor: Colors.tealAccent,
          buttonName: 'rgb flare',
          buttonTextColor: Colors.amber),
      buildButton(
          context: context,
          state: States.police,
          degree: 0,
          countButtonInRow: 3,
          leftGradienColor: Colors.red,
          rightGradienColor: Colors.blue,
          buttonName: 'police',
          buttonTextColor: Colors.white),
      buildScenarioButton(
          context: context,
          countButtonInRow: 3,
          leftGradienColor: Colors.yellow,
          rightGradienColor: Colors.green,
          buttonName: 'create scenario',
          buttonTextColor: Colors.blue)
    ];
  }

  void isGradualState(States state) {
    setState(() {
      if (state == States.whiteCoolGradual ||
          state == States.whiteRGBGradual ||
          state == States.whiteCoolAndWarmGradual) {
        stateForWhite = state;
      } else {
        stateForWhite = States.empty;
      }
    });
  }

  Widget buildButton(
      {required BuildContext context,
      required States state,
      required int degree,
      required int countButtonInRow,
      required Color leftGradienColor,
      required Color rightGradienColor,
      required String buttonName,
      required Color buttonTextColor}) {
    return GestureDetector(
      onTap: () {
        isGradualState(state);
        if (ledStateEnum == LedStateEnum.independent) {
          BlocProvider.of<BlDevicesBlocBloc>(context).add(
              BlDevicesBlocEventUpdateIndependent(
                  ledState: LedState(
                      name: ledState.ledName, state: state, degree: degree)));
        } else if (ledStateEnum == LedStateEnum.group) {
          BlocProvider.of<BlDevicesBlocBloc>(context).add(
              BlDevicesBlocEventUpdateGroup(
                  ledState: LedState(state: state, degree: degree)));
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 17,
        width: MediaQuery.of(context).size.width / (countButtonInRow + 0.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [leftGradienColor, rightGradienColor],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(100.0)),
        ),
        child: Center(
          child: Text(
            buttonName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: buttonTextColor,
                fontSize: 20.0),
          ),
        ),
      ),
    );
  }

  Widget buildScenarioButton(
      {required BuildContext context,
      required int countButtonInRow,
      required Color leftGradienColor,
      required Color rightGradienColor,
      required String buttonName,
      required Color buttonTextColor}) {
    return GestureDetector(
      onTap: () => BlocProvider.of<AppStateBlocBloc>(context)
          .add(AppStateBlocEventScenario()),
      child: Container(
        height: MediaQuery.of(context).size.height / 17,
        width: MediaQuery.of(context).size.width / (countButtonInRow + 0.5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [leftGradienColor, rightGradienColor],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(100.0)),
        ),
        child: Center(
          child: Text(
            buttonName,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: buttonTextColor,
                fontSize: 20.0),
          ),
        ),
      ),
    );
  }

  Widget buildButtonChangeLed(
      Set<LedState> ledStates,
      BuildContext context,
      int countButtonInRow,
      Color leftGradienColor,
      Color rightGradienColor,
      String buttonName,
      Color buttonTextColor) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text('Select Led'),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width / 1.5,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ledStates.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(ledStates.elementAt(index).ledName),
                        onTap: () {
                          setState(() {
                            ledState.setDeactivateInIndependent();
                            BlocProvider.of<BlDevicesBlocBloc>(context).add(
                                BlDevicesBlocEventUpdateIndependent(
                                    ledState: LedState(
                                        name: ledState.name,
                                        active: ledState.activeInIndependent)));
                            ledState = ledStates.elementAt(index);
                            ledState.setActiveInIndependent();
                            BlocProvider.of<BlDevicesBlocBloc>(context).add(
                                BlDevicesBlocEventUpdateIndependent(
                                    ledState: LedState(
                                        name: ledState.name,
                                        active: ledState.activeInIndependent)));
                            titleName =
                                'Control Panel. \n Selescted led: ${ledState.ledName}';
                          });
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                )
              ],
            );
          },
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 17,
        width: MediaQuery.of(context).size.width / (countButtonInRow + 0.3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [leftGradienColor, rightGradienColor],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Center(
          child: Text(
            buttonName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: buttonTextColor,
                fontSize: 18.0),
          ),
        ),
      ),
    );
  }

  Widget buildFloatingActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: () {
              if (ledStateEnum == LedStateEnum.independent) {
                BlocProvider.of<BlDevicesBlocBloc>(context).add(
                    BlDevicesBlocEventUpdateIndependent(
                        ledState: LedState(
                            name: ledState.ledName, state: States.disable)));
              } else if (ledStateEnum == LedStateEnum.group) {
                BlocProvider.of<BlDevicesBlocBloc>(context).add(
                    BlDevicesBlocEventUpdateGroup(
                        ledState: LedState(state: States.disable)));
              }
            },
            label: const Text('Disable')),
        if (ledStateEnum == LedStateEnum.independent)
          const SizedBox(
            width: 20,
          ),
        if (ledStateEnum == LedStateEnum.independent)
          buildButtonChangeLed(
              BlocProvider.of<BlDevicesBlocBloc>(context).independentLedsStates,
              context,
              3,
              Colors.black,
              Colors.black,
              'change led',
              Colors.white),
      ],
    );
  }
}
// Widget

// }
// Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               buildButton(
//                   context: context,
//                   state: States.strobo,
//                   degree: 0,
//                   countButtonInRow: 3,
//                   leftGradienColor: Colors.white,
//                   rightGradienColor: Colors.black,
//                   buttonName: 'strobo rgb',
//                   buttonTextColor: Colors.white),
//               buildButton(
//                   context: context,
//                   state: States.stroboStrongWhite,
//                   degree: 0,
//                   countButtonInRow: 3,
//                   leftGradienColor: Colors.white,
//                   rightGradienColor: Colors.black,
//                   buttonName: 'strobo cool',
//                   buttonTextColor: Colors.white),
//             ],
//           ),
//           Divider(
//               color: Colors.transparent, height: MediaQuery.of(context).size.height / 30),
//           Row(
//             mainAxisAlignment: ledStateEnum == LedStateEnum.independent
//                 ? MainAxisAlignment.spaceBetween
//                 : MainAxisAlignment.spaceAround,
//             children: buildButtonRowDependentOnLedState(ledStates).toList(),
//           ),
//           const Divider(color: Colors.transparent),
//         ]));
