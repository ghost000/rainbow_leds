import 'package:flutter/material.dart';
import 'package:rainbow_leds/bloc/blocs.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:rainbow_leds/widgets/bluetooth_off_screen.dart';

class ControlPanelScreen extends StatefulWidget {
  final _ControlPanelScreenState state = _ControlPanelScreenState();

  // ControlPanelScreen({this.statebl});
  //  ControlPanelScreen({ Key key, this.statebl }) : super(key: key);
  // final BluetoothState statebl;

  //get BluetoothState statebl => statebl;

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ControlPanelScreen());
  }

  @override
  _ControlPanelScreenState createState() => state;
}

class _ControlPanelScreenState extends State<ControlPanelScreen> {
  Color _groupInitialColor = Colors.amber;
  Color _independentInitialColor = Colors.blue;
  LedState _ledState;

  @override
  Widget build(BuildContext context) {
    // if (widget.statebl != BluetoothState.on) {
    //   //BlocProvider.of<AppStateBlocBloc>(context).add(AppStateBlocEventGroup());
    //   // myCallback(() {
    //   //   print("gggggggggggggggggggggggggggggggggggggggggggggggggggggg");
    //   //   Navigator.of(context).pushNamed('/BluetoothOffScreen');

    //   //   BlocProvider.of<AppStateBlocBloc>(context).add(AppStateBlocEventGroup());
    //   // });

    //     BlocProvider.of<AppStateBlocBloc>(context).add(AppStateBlocEventBluetoothOff());
    // }
    //listenState(context);
    //BlocProvider.of<AppStateBlocBloc>(context).listenFlutterBlue();
    return BlocListener<AppStateBlocBloc, AppStateBlocState>(
        cubit: BlocProvider.of<AppStateBlocBloc>(context),
        listener: (context, state) {
          // if (state is AppStateBlocBluetoothOff) {
          //   Navigator.of(context).pushNamed('/BluetoothOffScreen');
          // } else
          if (state is AppStateBlocGroup) {
            Navigator.of(context).pushNamed('/ControlPanelScreen');
          }
          // else if (state is AppStateBlocGroup) {
          //   Navigator.of(context).pop();
          // }
        },
        child: StreamBuilder<BluetoothState>(
            stream: FlutterBlue.instance.state,
            initialData: BluetoothState.unknown,
            builder: (context, snapshot) {
              if (snapshot.data != BluetoothState.on) {
                //BlocProvider.of<AppStateBlocBloc>(context).add(AppStateBlocEventGroup());
                // myCallback(() {
                //   print("gggggggggggggggggggggggggggggggggggggggggggggggggggggg");
                //   Navigator.of(context).pushNamed('/BluetoothOffScreen');

                //   BlocProvider.of<AppStateBlocBloc>(context).add(AppStateBlocEventGroup());
                // });

                // BlocProvider.of<AppStateBlocBloc>(context).add(AppStateBlocEventBluetoothOff());
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
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
                        body: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              buildIndependentControler(context),
                              buildGroupControler(context),
                            ]),
                      )),
                ),
              );
            }));
  }
  //       )
  //       );
  // }

  Widget buildGroupColorPanel(BuildContext context) {
    return Center(
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
    );
  }

  Widget buildIndependentColorPanel(BuildContext context) {
    //{LedState ledState, BuildContext context}) {
    //_ledState = ledState;
    //_independentInitialColor = ledState.color;
    return Center(
      child: CircleColorPicker(
        initialColor: _independentInitialColor,
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
        onChanged: _onIndependentColorChanged,
      ),
    );
  }

  void _onGroupColorChanged(Color color) {
    setState(() => _groupInitialColor = color);
    BlocProvider.of<BlDevicesBlocBloc>(context).add(
        BlDevicesBlocEventUpdateGroup(
            LedState(color: color, state: States.rgb)));
  }

  void _onIndependentColorChanged(Color color) {
    setState(() => _independentInitialColor = color);
    BlocProvider.of<BlDevicesBlocBloc>(context).add(
        BlDevicesBlocEventUpdateIndependent(
            LedState(name: _ledState.name, color: color, state: States.rgb)));
  }

  Widget buildIndependentControler(BuildContext context) {
    return StreamBuilder(
        stream: BlocProvider.of<BlDevicesBlocBloc>(context)
            .independentLedsStatesStream,
        initialData: BlocProvider.of<BlDevicesBlocBloc>(context)
            .independentLedsStates, //{LedState(name: "EMPTY", color: Color(0xFF007700))},
        builder: (context, snapshot) =>
            buildIndependentControlPanel(context)); //snapshot.data, context));
  }

  Widget buildGroupControler(BuildContext context) {
    return StreamBuilder(
        stream:
            BlocProvider.of<BlDevicesBlocBloc>(context).groupLedsStatesStream,
        initialData: BlocProvider.of<BlDevicesBlocBloc>(context)
            .groupLedsStates, //{LedState(name: "EMPTY")},
        builder: (context, snapshot) => buildGroupColorPanel(context));
  }

  // Widget buildSidePanel(Set<LedState> ledStates, BuildContext context) {}

  Widget buildIndependentControlPanel(BuildContext context) {
    //Set<LedState> ledStates, BuildContext context) {
    return buildIndependentColorPanel(
        context); //ledState: ledStates.first, context: context);
  }
}

listenState(context) {
  FlutterBlue.instance.state.listen((event) {
    if (event == BluetoothState.on) {
      BlocProvider.of<AppStateBlocBloc>(context).add(AppStateBlocEventGroup());
    } else {
      BlocProvider.of<AppStateBlocBloc>(context)
          .add(AppStateBlocEventBluetoothOff());
    }
  });
}

void myCallback(Function callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}
