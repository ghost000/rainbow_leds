import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rainbow_leds/bloc/blocs.dart';
import 'package:rainbow_leds/widgets/bluetooth_off_screen.dart';

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AppStateBlocBloc, AppStateBlocState>(
        cubit: BlocProvider.of<AppStateBlocBloc>(context),
        listener: (context, state) {
          if (state is AppStateBlocControl) {
            Navigator.of(context).pushNamed('/ControlPanelScreen');
          }
        },
        child: StreamBuilder<BluetoothState>(
            stream: FlutterBlue.instance.state,
            initialData: BluetoothState.unknown,
            builder: (context, snapshot) {
              if (snapshot.data != BluetoothState.on) {
                return BluetoothOffScreen(state: snapshot.data);
              }
              return Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Scaffold(
                  appBar: AppBar(
                    title: Text("Find devices"),
                  ),
                  //backgroundColor: Colors.lightBlue,
                  body: buildRefreshIndicator(context),
                  bottomNavigationBar: BottomAppBar(
                    shape: const CircularNotchedRectangle(),
                    child: Container(
                      height: 50.0,
                    ),
                  ),
                  floatingActionButton: buildfloatingActionButton(
                      context), //buildStreamBuilder(context),

                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                ),
              );
            }));
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
              initialData: {LedState(name: "EMPTY")},
              builder: (context, snapshot) => buildScanResultsColumn(
                  snapshot.data, LedStateEnum.notAssigned, context)),
          Text(
            "groupLedsStatesStream",
            textAlign: TextAlign.left,
          ),
          StreamBuilder(
              stream: BlocProvider.of<BlDevicesBlocBloc>(context)
                  .groupLedsStatesStream,
              initialData: {LedState(name: "EMPTY")},
              builder: (context, snapshot) => buildScanResultsColumn(
                  snapshot.data, LedStateEnum.group, context)),
          Text(
            "independentLedsStatesStream",
            textAlign: TextAlign.left,
          ),
          StreamBuilder(
              stream: BlocProvider.of<BlDevicesBlocBloc>(context)
                  .independentLedsStatesStream,
              initialData: {LedState(name: "EMPTY")},
              builder: (context, snapshot) => buildScanResultsColumn(
                  snapshot.data, LedStateEnum.independent, context))
        ],
      ));
}

Widget buildScanResultsColumn(Set<LedState> scanResults,
    LedStateEnum ledStateEnum, BuildContext context) {
  return Column(children: <Widget>[
    Divider(color: Colors.black),
    ...scanResults.map((scanResult) {
      print(scanResult.toString()); //debug print
      return buildTextAndButtons(scanResult, ledStateEnum, context);
    }).toList(),
  ]);
}

Widget buildTextAndButtons(
    LedState scanResult, LedStateEnum ledStateEnum, BuildContext context) {
  final String name = scanResult.name.toString();
  return Column(children: <Widget>[
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Align(
          child: Text("$name"),
          alignment: FractionalOffset.topLeft,
        )
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buildButtons(scanResult, ledStateEnum, context),
    )
  ]);
}

List<Widget> buildButtons(
    LedState scanResult, LedStateEnum ledStateEnum, BuildContext context) {
  List<Widget> widgetList = List<Widget>();
  if (ledStateEnum == LedStateEnum.group) {
    widgetList
      ..add(buildIndependentFlatButton(scanResult, context))
      ..add(buildNotAssignedFlatButton(scanResult, context))
      ..add(buildConnectDisconnectFlatButton(
          scanResult, context, GroupOrIndependent.group));
  } else if (ledStateEnum == LedStateEnum.independent) {
    widgetList
      ..add(buildGroupFlatButton(scanResult, context))
      ..add(buildNotAssignedFlatButton(scanResult, context))
      ..add(buildConnectDisconnectFlatButton(
          scanResult, context, GroupOrIndependent.independent));
  } else if (ledStateEnum == LedStateEnum.notAssigned) {
    widgetList
      ..add(buildGroupFlatButton(scanResult, context))
      ..add(buildIndependentFlatButton(scanResult, context));
  }
  return widgetList;
}

Widget buildIndependentFlatButton(LedState scanResult, BuildContext context) {
  return Align(
    child: FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.cyan)),
      color: Colors.cyanAccent,
      onPressed: () {
        BlocProvider.of<BlDevicesBlocBloc>(context).add(
            BlDevicesBlocEventAddToIndependent(LedState(
                name: scanResult.name,
                characteristic: scanResult.getCharacteristic,
                bluetoothDevice: scanResult.getBluetoothDevice)));
      },
      child: Text("ADD independent"),
    ),
    alignment: Alignment.centerRight,
  );
}

Widget buildGroupFlatButton(LedState scanResult, BuildContext context) {
  return Align(
    child: FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.amber)),
      color: Colors.amberAccent,
      onPressed: () {
        BlocProvider.of<BlDevicesBlocBloc>(context).add(
            BlDevicesBlocEventAddToGroup(LedState(
                name: scanResult.name,
                characteristic: scanResult.getCharacteristic,
                bluetoothDevice: scanResult.getBluetoothDevice)));
      },
      child: Text("ADD Group"),
    ),
    alignment: FractionalOffset.topRight,
  );
}

Widget buildNotAssignedFlatButton(LedState scanResult, BuildContext context) {
  return Align(
    child: FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.purple)),
      color: Colors.purpleAccent,
      onPressed: () {
        BlocProvider.of<BlDevicesBlocBloc>(context).add(
            BlDevicesBlocEventAddToNotAssigned(LedState(
                name: scanResult.name,
                characteristic: scanResult.getCharacteristic,
                bluetoothDevice: scanResult.getBluetoothDevice)));
      },
      child: Text("ADD NotAssigned"),
    ),
    alignment: FractionalOffset.topRight,
  );
}

Widget buildConnectDisconnectFlatButton(LedState scanResult,
    BuildContext context, GroupOrIndependent groupOrIndependent) {
  if (scanResult.getBluetoothDevice != null) {
    return StreamBuilder<BluetoothDeviceState>(
        stream: scanResult.getBluetoothDevice.state,
        initialData: BluetoothDeviceState.disconnected,
        builder: (context, snapshot) {
          if (snapshot.data == BluetoothDeviceState.disconnected) {
            return Align(
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.green)),
                color: Colors.greenAccent,
                onPressed: () {
                  BlocProvider.of<BlDevicesBlocBloc>(context).add(
                      BlDevicesBlocEventConnect(
                          scanResult, groupOrIndependent));
                },
                child: Text("Connect"),
              ),
              alignment: FractionalOffset.topRight,
            );
          } else {
            return Align(
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.red)),
                color: Colors.redAccent,
                onPressed: () {
                  BlocProvider.of<BlDevicesBlocBloc>(context).add(
                      BlDevicesBlocEventDisconnect(
                          scanResult, groupOrIndependent));
                },
                child: Text("Disconnect"),
              ),
              alignment: FractionalOffset.topRight,
            );
          }
        });
  } else {
    return Divider(color: Colors.transparent);
  }
}

// StreamBuilder<bool> buildStreamBuilder(BuildContext context, Stream<bool> boolStream, Widget buildFlatButton(bool scanResult, BuildContext context)) {
//   return StreamBuilder<bool>(
//     stream: boolStream,
//     initialData: false,
//     builder: (context, snapshot) => buildFlatButton, context),
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
    child: Icon(
      Icons.design_services,
      size: 35,
    ),
    onPressed: () => BlocProvider.of<AppStateBlocBloc>(context)
        .add(AppStateBlocEventControl()),
    backgroundColor: Colors.white60,
  );
}
