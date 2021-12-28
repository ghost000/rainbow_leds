import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../bloc/blocs.dart';
import '../bloc/multiple_stream_builder.dart';
import 'bluetooth_off_screen.dart';

class FindDevicesScreen extends StatelessWidget {
  const FindDevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppStateBlocBloc, AppStateBlocState>(
        bloc: BlocProvider.of<AppStateBlocBloc>(context),
        listener: (context, state) {
          if (state is AppStateBlocControlIndependentAndGroup) {
            Navigator.of(context)
                .pushNamed('/ControlPanelIndependentAndGroupScreen');
          }
          if (state is AppStateBlocControlIndependent) {
            Navigator.of(context).pushNamed('/ControlPanelIndependentScreen');
          }
          if (state is AppStateBlocControlGroup) {
            Navigator.of(context).pushNamed('/ControlPanelGroupScreen');
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
                    appBar: NeumorphicAppBar(
                      centerTitle: true,
                      title: NeumorphicText(
                        "Find devices",
                        style: NeumorphicStyle(
                          shadowLightColor: Colors.green,
                          depth: 5,
                          color: Colors.white,
                          border: const NeumorphicBorder.none(),
                        ),
                        textStyle: NeumorphicTextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    body: buildRefreshIndicator(context),
                    floatingActionButton:
                        buildFloatingActionButtonFromDuobleStreams(context),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat),
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
            'Not assigned',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20.0),
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
            'Group',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20.0),
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
            'Independent',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20.0),
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

Widget buildScanResultsColumn(Set<LedState>? scanResults,
    LedStateEnum ledStateEnum, BuildContext context) {
  return Column(children: <Widget>[
    const Divider(color: Colors.white),
    ...scanResults!.map((scanResult) {
      return buildTextAndButtons(scanResult, ledStateEnum, context);
    }).toList(),
  ]);
}

Widget buildTextAndButtons(
    LedState scanResult, LedStateEnum ledStateEnum, BuildContext context) {
  return Column(children: <Widget>[
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Align(
          alignment: FractionalOffset.topLeft,
          child: Text("${scanResult.secondName} : ${scanResult.name}"),
        )
      ],
    ),
    Container(
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: buildButtons(scanResult, ledStateEnum, context),
        ))
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

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  backgroundColor: Colors.amber,
  primary: Colors.green,
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      side: BorderSide(color: Colors.blue)),
);

Widget buildIndependentFlatButton(LedState scanResult, BuildContext context) {
  return Align(
    alignment: Alignment.centerRight,
    child: NeumorphicButton(
      //style: flatButtonStyle,
      onPressed: () {
        scanResult.setDeactivateInIndependent();

        final tmpLedState = LedState(
            name: scanResult.name,
            secondName: scanResult.secondName,
            active: scanResult.activeInIndependent);
        tmpLedState.ledCharacteristic = scanResult.ledCharacteristic;
        tmpLedState.ledBluetoothDevice = scanResult.ledBluetoothDevice;

        BlocProvider.of<BlDevicesBlocBloc>(context)
            .add(BlDevicesBlocEventAddToIndependent(ledState: tmpLedState));
      },
      child: const Text('ADD independent'),
    ),
  );
}

Widget buildGroupFlatButton(LedState scanResult, BuildContext context) {
  return Align(
    alignment: FractionalOffset.topRight,
    child: NeumorphicButton(
      onPressed: () {
        scanResult.setDeactivateInIndependent();

        final tmpLedState = LedState(
            name: scanResult.name,
            secondName: scanResult.secondName,
            active: scanResult.activeInIndependent);
        tmpLedState.ledCharacteristic = scanResult.ledCharacteristic;
        tmpLedState.ledBluetoothDevice = scanResult.ledBluetoothDevice;

        BlocProvider.of<BlDevicesBlocBloc>(context)
            .add(BlDevicesBlocEventAddToGroup(ledState: tmpLedState));
      },
      child: const Text('ADD Group'),
    ),
  );
}

Widget buildNotAssignedFlatButton(LedState scanResult, BuildContext context) {
  return Align(
    alignment: FractionalOffset.topRight,
    child: NeumorphicButton(
      onPressed: () {
        scanResult.setDeactivateInIndependent();

        final tmpLedState = LedState(
            name: scanResult.name,
            secondName: scanResult.secondName,
            active: scanResult.activeInIndependent);
        tmpLedState.ledCharacteristic = scanResult.ledCharacteristic;
        tmpLedState.ledBluetoothDevice = scanResult.ledBluetoothDevice;

        BlocProvider.of<BlDevicesBlocBloc>(context)
            .add(BlDevicesBlocEventAddToNotAssigned(ledState: tmpLedState));
      },
      child: const Text('ADD NotAssigned'),
    ),
  );
}

Widget buildConnectDisconnectFlatButton(LedState scanResult,
    BuildContext context, GroupOrIndependent groupOrIndependent) {
  if (scanResult.ledBluetoothDevice != null) {
    return StreamBuilder<BluetoothDeviceState>(
        stream: scanResult.ledBluetoothDevice!.state,
        initialData: BluetoothDeviceState.disconnected,
        builder: (context, snapshot) {
          return Align(
              alignment: FractionalOffset.topRight,
              child: NeumorphicSwitch(
                value: snapshot.data != BluetoothDeviceState.disconnected,
                onChanged: (value) {
                  if (value) {
                    BlocProvider.of<BlDevicesBlocBloc>(context).add(
                        BlDevicesBlocEventConnect(
                            ledState: scanResult,
                            groupOrIndependent: groupOrIndependent));
                  } else {
                    BlocProvider.of<BlDevicesBlocBloc>(context).add(
                        BlDevicesBlocEventConnect(
                            ledState: scanResult,
                            groupOrIndependent: groupOrIndependent));
                  }
                },
              ));
        });
  } else {
    return const Divider(color: Colors.transparent);
  }
}

Widget buildFloatingActionButtonFromDuobleStreams(BuildContext context) {
  return DoubleStreamBuilder(
    streamIndependent:
        BlocProvider.of<BlDevicesBlocBloc>(context).independentLedsStatesStream,
    streamGroup:
        BlocProvider.of<BlDevicesBlocBloc>(context).groupLedsStatesStream,
    builder: buildFloatingButtonFromDoubleStreams,
  );
}

Widget buildFloatingButtonFromDoubleStreams(
    BuildContext context, LedStateStream? ledStateStream) {
  if (ledStateStream == LedStateStream.both) {
    return NeumorphicButton(
        onPressed: () => BlocProvider.of<AppStateBlocBloc>(context)
            .add(AppStateBlocEventControlIndependentAndGroup()),
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
        ),
        child: Row(children: [
          const Icon(
            Icons.design_services,
            size: 35,
            color: Colors.white,
          ),
          const Text('Independent and group', style: TextStyle(color: Colors.white)),
        ], mainAxisSize: MainAxisSize.min));
  } else if (ledStateStream == LedStateStream.independent) {
    return NeumorphicButton(
        onPressed: () => BlocProvider.of<AppStateBlocBloc>(context)
            .add(AppStateBlocEventControlIndependent()),
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
        ),
        child: Row(children: [
          const Icon(
            Icons.design_services,
            size: 35,
            color: Colors.white,
          ),
          const Text('Independent', style: TextStyle(color: Colors.white)),
        ], mainAxisSize: MainAxisSize.min));
  } else if (ledStateStream == LedStateStream.group) {
    return NeumorphicButton(
        onPressed: () => BlocProvider.of<AppStateBlocBloc>(context)
            .add(AppStateBlocEventControlGroup()),
        style: NeumorphicStyle(
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
        ),
        child: Row(children: [
        const Icon(
          Icons.design_services,
          size: 35,
          color: Colors.white,
        ),
        const Text('Group', style: TextStyle(color: Colors.white)),
        ], mainAxisSize: MainAxisSize.min));
  };

  return NeumorphicButton(
      onPressed: () async {
        await FlutterBlue.instance.startScan(
            scanMode: ScanMode.lowPower, timeout: const Duration(seconds: 4));
      },
      style: NeumorphicStyle(
        shape: NeumorphicShape.convex,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(100)),
      ),
      child: Row(children: [
        const Icon(
          Icons.compare_arrows,
          size: 35,
          color: Colors.white,
        ),
        const Text('SEARCH', style: TextStyle(color: Colors.white)),
      ], mainAxisSize: MainAxisSize.min));
}
