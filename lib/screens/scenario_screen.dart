import 'package:flutter/material.dart';
import 'package:rainbow_leds/bloc/blocs.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rainbow_leds/screens/bluetooth_off_screen.dart';

class ScenarioSetterScreen extends StatefulWidget {
  const ScenarioSetterScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => ScenarioSetterScreenState();
}

class ScenarioSetterScreenState extends State<ScenarioSetterScreen> {
  List<Step> stepContainer = <Step>[];

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
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text('Scenario Setter'),
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[buildStepper(context)],
                      ),
                    ),
                  )));
        });
  }

  Widget buildStepper(BuildContext context) {
    return Stepper(
      steps: const [
        Step(
          title: Text('Start'),
          content: Text('Before starting, we should create a page.'),
        ),
        Step(
          title: Text('Constructor'),
          content: Text("Let's look at its construtor."),
        ),
      ],
    );
  }
}

List<Step> buildSteps(BuildContext context) {
  List<Step> test = <Step>[];
  return test;
}
