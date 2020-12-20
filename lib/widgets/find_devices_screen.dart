import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rainbow_leds/bloc/blocs.dart';

enum LedStateEnum { group, notAssigned, independent }

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Find devices"),
      ),
      backgroundColor: Colors.lightBlue,
      body: buildRefreshIndicator(context),
      floatingActionButton:
          buildfloatingActionButton(context), //buildStreamBuilder(context),
    );
  }
}

Widget buildRefreshIndicator(BuildContext context) {
  return RefreshIndicator(
      onRefresh: () => FlutterBlue.instance.startScan(
          scanMode: ScanMode.lowPower, timeout: Duration(seconds: 4)),
      child: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: <Widget>[
          Text(
            "notAssignedLedsStates",
            textAlign: TextAlign.left,
          ),
          StreamBuilder(
              stream: BlocProvider.of<BlDevicesBlocBloc>(context)
                  .notAssignedLedsStatesStream,
              initialData: {LedState("EMPTY")},
              builder: (context, snapshot) => buildScanResultsColumn(
                  snapshot.data, LedStateEnum.notAssigned, context)),
          Text(
            "groupLedsStatesStream",
            textAlign: TextAlign.left,
          ),
          StreamBuilder(
              stream: BlocProvider.of<BlDevicesBlocBloc>(context)
                  .groupLedsStatesStream,
              initialData: {LedState("EMPTY")},
              builder: (context, snapshot) => buildScanResultsColumn(
                  snapshot.data, LedStateEnum.group, context)),
          Text(
            "independentLedsStatesStream",
            textAlign: TextAlign.left,
          ),
          StreamBuilder(
              stream: BlocProvider.of<BlDevicesBlocBloc>(context)
                  .independentLedsStatesStream,
              initialData: {LedState("EMPTY")},
              builder: (context, snapshot) => buildScanResultsColumn(
                  snapshot.data, LedStateEnum.independent, context))
        ],
      ));
}

Widget buildScanResultsColumn(Set<LedState> scanResults,
    LedStateEnum ledStateEnum, BuildContext context) {
  return Column(children: <Widget>[
    new Divider(color: Colors.blue),
    ...scanResults.map((scanResult) {
      print(scanResult.toString()); //debug print
      return buildTextAndButtons(scanResult, ledStateEnum, context);
    }).toList(),
  ]);
}

Widget buildTextAndButtons(
    LedState scanResult, LedStateEnum ledStateEnum, BuildContext context) {
  final String name = scanResult.name.toString();
  return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Align(
          child: new Text("$name"),
          alignment: FractionalOffset.topLeft,
        ),
        ...buildButtons(scanResult, ledStateEnum, context),
      ]);
}

List<Widget> buildButtons(
    LedState scanResult, LedStateEnum ledStateEnum, BuildContext context) {
  List<Widget> widgetList = List<Widget>();
  if (ledStateEnum == LedStateEnum.group) {
    widgetList
      ..add(buildIndependentFlatButton(scanResult, context))
      ..add(buildNotAssignedFlatButton(scanResult, context));
  } else if (ledStateEnum == LedStateEnum.independent) {
    widgetList
      ..add(buildGroupFlatButton(scanResult, context))
      ..add(buildNotAssignedFlatButton(scanResult, context));
  } else if (ledStateEnum == LedStateEnum.notAssigned) {
    widgetList
      ..add(buildGroupFlatButton(scanResult, context))
      ..add(buildIndependentFlatButton(scanResult, context));
  }
  return widgetList;
}



Widget buildIndependentFlatButton(LedState scanResult, BuildContext context) {
  return new Align(
    child: new FlatButton(
      onPressed: () {
        BlocProvider.of<BlDevicesBlocBloc>(context)
            .add(BlDevicesBlocEventAddToIndependent(LedState(scanResult.name)));
      },
      child: new Text("ADD independent"),
    ),
    alignment: Alignment.centerRight,
  );
}

Widget buildGroupFlatButton(LedState scanResult, BuildContext context) {
  return new Align(
    child: new FlatButton(
      onPressed: () {
        BlocProvider.of<BlDevicesBlocBloc>(context)
            .add(BlDevicesBlocEventAddToGroup(LedState(scanResult.name)));
      },
      child: new Text("ADD Group"),
    ),
    alignment: FractionalOffset.topRight,
  );
}

Widget buildNotAssignedFlatButton(LedState scanResult, BuildContext context) {
  return new Align(
    child: new FlatButton(
      onPressed: () {
        BlocProvider.of<BlDevicesBlocBloc>(context)
            .add(BlDevicesBlocEventAddToNotAssigned(LedState(scanResult.name)));
      },
      child: new Text("ADD NotAssigned"),
    ),
    alignment: FractionalOffset.topRight,
  );
}

// StreamBuilder<bool> buildStreamBuilder(BuildContext context) {
//   return StreamBuilder<bool>(
//     stream: FlutterBlue.instance.isScanning,
//     initialData: false,
//     builder: (context, snapshot) => buildfloatingActionButton(snapshot.data, context),
//   );
// }

// Widget buildfloatingActionButton(bool isScanning, BuildContext context) {
//   if (isScanning) {
//     return FloatingActionButton(
//       child: Icon(Icons.stop),
//       onPressed: () => FlutterBlue.instance.stopScan(),
//       backgroundColor: Colors.red,
//     );
//   } else {
//     return FloatingActionButton(
//         child: Icon(Icons.search),
//         onPressed: () => FlutterBlue.instance
//             .startScan(scanMode: ScanMode.lowLatency, timeout: Duration(seconds: 20)));
//   }
// }

Widget buildfloatingActionButton(BuildContext context) {
  return FloatingActionButton(
    child: Icon(Icons.stop),
    onPressed: () => BlocProvider.of<AppStateBlocBloc>(context)
        .add(AppStateBlocEventControl()),
    backgroundColor: Colors.blue,
  );
}
