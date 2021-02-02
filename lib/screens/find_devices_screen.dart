import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rainbow_leds/bloc/blocs.dart';
import 'package:rainbow_leds/screens/bluetooth_off_screen.dart';

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
                    title: const Text("Find devices"),
                  ),
                  body: buildRefreshIndicator(context),
                  bottomNavigationBar: BottomAppBar(
                    shape: const CircularNotchedRectangle(),
                    child: Container(
                      height: 50.0,
                    ),
                  ),
                  floatingActionButton: buildfloatingActionButton(
                      context),

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
          scanMode: ScanMode.lowPower, timeout: const Duration(seconds: 4)),
      child: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: <Widget>[
          const Text(
            "notAssignedLedsStates",
            textAlign: TextAlign.left,
          ),
          StreamBuilder(
              stream: BlocProvider.of<BlDevicesBlocBloc>(context)
                  .notAssignedLedsStatesStream,
              initialData: BlocProvider.of<BlDevicesBlocBloc>(context)
                  .notAssignedLedsStates,
              builder: (context, AsyncSnapshot<Set<LedState>> snapshot) =>
                  buildScanResultsColumn(
                      snapshot.data, LedStateEnum.notAssigned, context)),
          const Text(
            "groupLedsStatesStream",
            textAlign: TextAlign.left,
          ),
          StreamBuilder(
              stream: BlocProvider.of<BlDevicesBlocBloc>(context)
                  .groupLedsStatesStream,
              initialData:
                  BlocProvider.of<BlDevicesBlocBloc>(context).groupLedsStates,
              builder: (context, AsyncSnapshot<Set<LedState>> snapshot) =>
                  buildScanResultsColumn(
                      snapshot.data, LedStateEnum.group, context)),
          const Text(
            "independentLedsStatesStream",
            textAlign: TextAlign.left,
          ),
          StreamBuilder(
              stream: BlocProvider.of<BlDevicesBlocBloc>(context)
                  .independentLedsStatesStream,
              initialData: BlocProvider.of<BlDevicesBlocBloc>(context)
                  .independentLedsStates,
              builder: (context, AsyncSnapshot<Set<LedState>> snapshot) =>
                  buildScanResultsColumn(
                      snapshot.data, LedStateEnum.independent, context))
        ],
      ));
}

Widget buildScanResultsColumn(Set<LedState> scanResults,
    LedStateEnum ledStateEnum, BuildContext context) {
  return Column(children: <Widget>[
    const Divider(color: Colors.black),
    ...scanResults.map((scanResult) {
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
          alignment: FractionalOffset.topLeft,
          child: Text(name),
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
  if (ledStateEnum == LedStateEnum.group) {
    return <Widget>[
      buildIndependentFlatButton(scanResult, context),
      buildNotAssignedFlatButton(scanResult, context),
      buildConnectDisconnectFlatButton(
          scanResult, context, GroupOrIndependent.group)
    ];
  } else if (ledStateEnum == LedStateEnum.independent) {
    return <Widget>[
      buildGroupFlatButton(scanResult, context),
      buildNotAssignedFlatButton(scanResult, context),
      buildConnectDisconnectFlatButton(
          scanResult, context, GroupOrIndependent.independent)
    ];
  } else if (ledStateEnum == LedStateEnum.notAssigned) {
    return <Widget>[
      buildGroupFlatButton(scanResult, context),
      buildIndependentFlatButton(scanResult, context)
    ];
  }
  return <Widget>[];
}

Widget buildIndependentFlatButton(LedState scanResult, BuildContext context) {
  return Align(
    alignment: Alignment.centerRight,
    child: FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Colors.cyan)),
      color: Colors.cyanAccent,
      onPressed: () {
        scanResult.setDeactivateInIndependent();
        BlocProvider.of<BlDevicesBlocBloc>(context).add(
            BlDevicesBlocEventAddToIndependent(LedState(
                name: scanResult.name,
                characteristic: scanResult.ledCharacteristic,
                bluetoothDevice: scanResult.ledBluetoothDevice,
                active: scanResult.activeInIndependent)));
      },
      child: const Text("ADD independent"),
    ),
  );
}

Widget buildGroupFlatButton(LedState scanResult, BuildContext context) {
  return Align(
    alignment: FractionalOffset.topRight,
    child: FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Colors.amber)),
      color: Colors.amberAccent,
      onPressed: () {
        scanResult.setDeactivateInIndependent();
        BlocProvider.of<BlDevicesBlocBloc>(context).add(
            BlDevicesBlocEventAddToGroup(LedState(
                name: scanResult.name,
                characteristic: scanResult.ledCharacteristic,
                bluetoothDevice: scanResult.ledBluetoothDevice,
                active: scanResult.activeInIndependent)));
      },
      child: const Text("ADD Group"),
    ),
  );
}

Widget buildNotAssignedFlatButton(LedState scanResult, BuildContext context) {
  return Align(
    alignment: FractionalOffset.topRight,
    child: FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Colors.purple)),
      color: Colors.purpleAccent,
      onPressed: () {
        scanResult.setDeactivateInIndependent();
        BlocProvider.of<BlDevicesBlocBloc>(context).add(
            BlDevicesBlocEventAddToNotAssigned(LedState(
                name: scanResult.name,
                characteristic: scanResult.ledCharacteristic,
                bluetoothDevice: scanResult.ledBluetoothDevice,
                active: scanResult.activeInIndependent)));
      },
      child: const Text("ADD NotAssigned"),
    ),
  );
}

Widget buildConnectDisconnectFlatButton(LedState scanResult,
    BuildContext context, GroupOrIndependent groupOrIndependent) {
  if (scanResult.ledBluetoothDevice != null) {
    return StreamBuilder<BluetoothDeviceState>(
        stream: scanResult.ledBluetoothDevice.state,
        initialData: BluetoothDeviceState.disconnected,
        builder: (context, snapshot) {
          if (snapshot.data == BluetoothDeviceState.disconnected) {
            return Align(
              alignment: FractionalOffset.topRight,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Colors.green)),
                color: Colors.greenAccent,
                onPressed: () {
                  BlocProvider.of<BlDevicesBlocBloc>(context).add(
                      BlDevicesBlocEventConnect(
                          scanResult, groupOrIndependent));
                },
                child: const Text("Connect"),
              ),
            );
          } else {
            return Align(
              alignment: FractionalOffset.topRight,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Colors.red)),
                color: Colors.redAccent,
                onPressed: () {
                  BlocProvider.of<BlDevicesBlocBloc>(context).add(
                      BlDevicesBlocEventDisconnect(
                          scanResult, groupOrIndependent));
                },
                child: const Text("Disconnect"),
              ),
            );
          }
        });
  } else {
    return const Divider(color: Colors.transparent);
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
    onPressed: () => BlocProvider.of<AppStateBlocBloc>(context)
        .add(AppStateBlocEventControl()),
    backgroundColor: Colors.black,
    child: const Icon(
      Icons.design_services,
      size: 35,
      color: Colors.white,
    ),
  );
}
