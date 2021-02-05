import 'package:flutter/material.dart';
import 'package:rainbow_leds/bloc/blocs.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:rainbow_leds/screens/bluetooth_off_screen.dart';

class ControlPanelScreen extends StatefulWidget {
  @override
  _ControlPanelScreenState createState() => _ControlPanelScreenState();
}

class _ControlPanelScreenState extends State<ControlPanelScreen> {
  Color _groupInitialColor = Colors.amber;
  LedState _ledState;
  int _value;
  String _titleName = 'Control Panel.';
  bool _testIndependentFlag = false;
  bool _testGroupFlag = false;
  States _stateForWhite;

  void setTitleNameAfterBuildIndependent() {
    setState(() {
      _testIndependentFlag = true;
      _titleName = 'Control Panel. \n Selescted led: ${_ledState.ledName}';
    });
  }

  void setTitleNameAfterBuildGroup() {
    setState(() {
      _testGroupFlag = true;
      _titleName = 'Control Panel. Group leds';
    });
  }

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
              BlocProvider.of<AppStateBlocBloc>(context)
                  .add(AppStateBlocEventGroup());

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
                        preferredSize: const Size(0.0, 24.0),
                        child: TabBar(
                          onTap: (value) {
                            value == 0
                                ? setTitleNameAfterBuildIndependent()
                                : setTitleNameAfterBuildGroup();
                          },
                          tabs: const [
                            Tab(
                              icon: Icon(Icons.format_italic),
                            ),
                            Tab(
                              icon: Icon(Icons.format_list_numbered),
                            )
                          ],
                        ),
                      ),
                      title: Text(_titleName),
                    ),
                    body: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
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
              buildColorPanel(context, LedStateEnum.independent),
              buildButtons(snapshot.data, LedStateEnum.independent, context)
            ],
          );
        });
  }

  void getActiveLedOrCheckFirst(Set<LedState> ledStates) {
    for (final ledState in ledStates) {
      if (ledState.activeInIndependent) {
        _ledState = ledState;
        return;
      }
    }
    _ledState = ledStates.first;
    _ledState.setActiveInIndependent();
    BlocProvider.of<BlDevicesBlocBloc>(context).add(
        BlDevicesBlocEventUpdateIndependent(LedState(
            name: _ledState.name, active: _ledState.activeInIndependent)));
  }

  void addPostBuildCallbackToSetSelectedOrFirstLedName() {
    if (!_testIndependentFlag && _ledState.name.isNotEmpty) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => setTitleNameAfterBuildIndependent());
    }
  }

  void _onIndependentColorChanged(Color color) {
    setState(() => _ledState.color = color);
    BlocProvider.of<BlDevicesBlocBloc>(context).add(
        BlDevicesBlocEventUpdateIndependent(
            LedState(name: _ledState.name, color: color, state: States.rgb)));
  }

  Widget buildGroupControler(BuildContext context) {
    if (!_testGroupFlag) {
      WidgetsBinding.instance
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
              buildColorPanel(context, LedStateEnum.group),
              buildButtons(snapshot.data, LedStateEnum.group, context)
            ],
          );
        });
  }

  Widget buildColorPanel(BuildContext context, LedStateEnum ledStateEnum) {
    return Center(
        child: Align(
      alignment: Alignment.topCenter,
      child: CircleColorPicker(
        initialColor: ledStateEnum == LedStateEnum.independent
            ? _ledState.color
            : _groupInitialColor,
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
              color: Colors.white70,
            ),
          );
        },
        onChanged: ledStateEnum == LedStateEnum.independent
            ? _onIndependentColorChanged
            : _onGroupColorChanged,
      ),
    ));
  }

  void _onGroupColorChanged(Color color) {
    setState(() => _groupInitialColor = color);
    BlocProvider.of<BlDevicesBlocBloc>(context).add(
        BlDevicesBlocEventUpdateGroup(
            LedState(color: color, state: States.rgb)));
  }

  void whiteUpdate(LedStateEnum ledStateEnum) {
    if (_stateForWhite == States.whiteCoolGradual ||
        _stateForWhite == States.whiteRGBGradual ||
        _stateForWhite == States.whiteCoolAndWarmGradual) {
      if (ledStateEnum == LedStateEnum.independent) {
        BlocProvider.of<BlDevicesBlocBloc>(context).add(
            BlDevicesBlocEventUpdateIndependent(LedState(
                name: _ledState.ledName,
                state: _stateForWhite,
                degree: _value)));
      } else if (ledStateEnum == LedStateEnum.group) {
        BlocProvider.of<BlDevicesBlocBloc>(context).add(
            BlDevicesBlocEventUpdateGroup(
                LedState(state: _stateForWhite, degree: _value)));
      }
    }
  }

  Widget buildButtons(Set<LedState> ledStates, LedStateEnum ledStateEnum,
      BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white70,
              trackShape: const RoundedRectSliderTrackShape(),
              trackHeight: 4.0,
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
              value: _value?.toDouble() ?? 50,
              max: 99,
              divisions: 99,
              label: '$_value',
              onChanged: (value) {
                setState(
                  () {
                    _value = value.toInt();
                    whiteUpdate(ledStateEnum);
                  },
                );
              },
            ),
          ),
          Divider(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height / 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildButton(
                  context: context,
                  ledStateEnum: ledStateEnum,
                  state: States.whiteRGBGradual,
                  degree: 0,
                  countButtonInRow: 3,
                  leftGradienColor: Colors.white,
                  rightGradienColor: Colors.white,
                  buttonName: 'white rgb',
                  buttonTextColor: Colors.black),
              buildButton(
                  context: context,
                  ledStateEnum: ledStateEnum,
                  state: States.whiteCoolGradual,
                  degree: 0,
                  countButtonInRow: 3,
                  leftGradienColor: Colors.white,
                  rightGradienColor: Colors.white,
                  buttonName: 'white cool',
                  buttonTextColor: Colors.black),
              buildButton(
                  context: context,
                  ledStateEnum: ledStateEnum,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildButton(
                  context: context,
                  ledStateEnum: ledStateEnum,
                  state: States.strobo,
                  degree: 0,
                  countButtonInRow: 3,
                  leftGradienColor: Colors.white,
                  rightGradienColor: Colors.black,
                  buttonName: 'strobo rgb',
                  buttonTextColor: Colors.white),
              buildButton(
                  context: context,
                  ledStateEnum: ledStateEnum,
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
            mainAxisAlignment: ledStateEnum == LedStateEnum.independent
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.spaceAround,
            children: buildButtonRowDependentOnLedState(ledStates, ledStateEnum)
                .toList(),
          ),
          const Divider(color: Colors.transparent),
        ]));
  }

  List<Widget> buildButtonRowDependentOnLedState(
      Set<LedState> ledStates, LedStateEnum ledStateEnum) {
    return <Widget>[
      buildButton(
          context: context,
          ledStateEnum: ledStateEnum,
          state: States.rgbFlare,
          degree: 0,
          countButtonInRow: 3,
          leftGradienColor: Colors.deepPurpleAccent,
          rightGradienColor: Colors.tealAccent,
          buttonName: 'rgb flare',
          buttonTextColor: Colors.amber),
      buildButton(
          context: context,
          ledStateEnum: ledStateEnum,
          state: States.police,
          degree: 0,
          countButtonInRow: 3,
          leftGradienColor: Colors.red,
          rightGradienColor: Colors.blue,
          buttonName: 'police',
          buttonTextColor: Colors.white),
      if (ledStateEnum == LedStateEnum.independent)
        buildButtonChangeLed(ledStates, context, 3, Colors.black, Colors.black,
            'change led', Colors.white)
    ];
  }

  void isGradualState(States state) {
    setState(() {
      if (state == States.whiteCoolGradual ||
          state == States.whiteRGBGradual ||
          state == States.whiteCoolAndWarmGradual) {
        _stateForWhite = state;
      } else {
        _stateForWhite = States.empty;
      }
    });
  }

  Widget buildButton(
      {BuildContext context,
      LedStateEnum ledStateEnum,
      States state,
      int degree,
      int countButtonInRow,
      Color leftGradienColor,
      Color rightGradienColor,
      String buttonName,
      Color buttonTextColor}) {
    return GestureDetector(
      onTap: () {
        isGradualState(state);
        if (ledStateEnum == LedStateEnum.independent) {
          BlocProvider.of<BlDevicesBlocBloc>(context).add(
              BlDevicesBlocEventUpdateIndependent(LedState(
                  name: _ledState.ledName, state: state, degree: degree)));
        } else if (ledStateEnum == LedStateEnum.group) {
          BlocProvider.of<BlDevicesBlocBloc>(context).add(
              BlDevicesBlocEventUpdateGroup(
                  LedState(state: state, degree: degree)));
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
          child: SimpleDialog(
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
                          _ledState.setDeactivateInIndependent();
                          BlocProvider.of<BlDevicesBlocBloc>(context).add(
                              BlDevicesBlocEventUpdateIndependent(LedState(
                                  name: _ledState.name,
                                  active: _ledState.activeInIndependent)));
                          _ledState = ledStates.elementAt(index);
                          _ledState.setActiveInIndependent();
                          BlocProvider.of<BlDevicesBlocBloc>(context).add(
                              BlDevicesBlocEventUpdateIndependent(LedState(
                                  name: _ledState.name,
                                  active: _ledState.activeInIndependent)));
                          _titleName =
                              'Control Panel. \n Selescted led: ${_ledState.ledName}';
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              )
            ],
          ),
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
}
