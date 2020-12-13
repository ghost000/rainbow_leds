import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rainbow_leds/bloc/blocs.dart';

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find devices"),
      ),
      backgroundColor: Colors.lightBlue,
      body: buildRefreshIndicator(context),
      floatingActionButton: buildStreamBuilder(context),
    );
  }
}

Widget buildRefreshIndicator(BuildContext context) {
  return RefreshIndicator(
      onRefresh: () => FlutterBlue.instance
          .startScan(scanMode: ScanMode.lowPower, timeout: Duration(seconds: 4)),
      child: ListView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: <Widget>[
          Text("notAssignedLedsStates"),
          StreamBuilder(
              stream:
                  BlocProvider.of<BlDevicesBlocBloc>(context).notAssignedLedsStatesStream,
              initialData: {LedState("EMPTY")},
              builder: (context, snapshot) =>
                  buildScanResultsColumn(snapshot.data, context)),
          Text("groupLedsStatesStream"),
          StreamBuilder(
              stream: BlocProvider.of<BlDevicesBlocBloc>(context).groupLedsStatesStream,
              initialData: {LedState("EMPTY")},
              builder: (context, snapshot) =>
                  buildScanResultsColumn(snapshot.data, context)),
          Text("independentLedsStatesStream"),
          StreamBuilder(
              stream:
                  BlocProvider.of<BlDevicesBlocBloc>(context).independentLedsStatesStream,
              initialData: {LedState("EMPTY")},
              builder: (context, snapshot) =>
                  buildScanResultsColumn(snapshot.data, context))
        ],
      ));
}

Widget buildScanResultsColumn(Set<LedState> scanResults, BuildContext context) {
  return Column(
    children: scanResults.map((scanResult) {
      print(scanResult.toString()); //debug print
      return buildTextAndButtons(scanResult, context);
    }).toList(),
  );
}

Widget buildTextAndButtons(LedState scanResult, BuildContext context) {
  final String name = scanResult.name.toString();
  return new Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
    new Align(
      child: new Text("$name debug print"),
      alignment: FractionalOffset.topLeft,
    ),
    new FlatButton(
        onPressed: () {
          BlocProvider.of<BlDevicesBlocBloc>(context)
              .add(BlDevicesBlocEventAddToIndependent(LedState(name)));
        },
        child: new Text("ADD independent")),
    new FlatButton(
        onPressed: () {
          BlocProvider.of<BlDevicesBlocBloc>(context)
              .add(BlDevicesBlocEventAddToGroup(LedState(name)));
        },
        child: new Text("ADD group")),
  ]);
}

StreamBuilder<bool> buildStreamBuilder(BuildContext context) {
  return StreamBuilder<bool>(
    stream: FlutterBlue.instance.isScanning,
    initialData: false,
    builder: (context, snapshot) => buildfloatingActionButton(snapshot.data, context),
  );
}

Widget buildfloatingActionButton(bool isScanning, BuildContext context) {
  if (isScanning) {
    return FloatingActionButton(
      child: Icon(Icons.stop),
      onPressed: () => FlutterBlue.instance.stopScan(),
      backgroundColor: Colors.red,
    );
  } else {
    return FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () => FlutterBlue.instance
            .startScan(scanMode: ScanMode.lowLatency, timeout: Duration(seconds: 20)));
  }
}
