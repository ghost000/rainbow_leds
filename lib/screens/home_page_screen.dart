import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rainbow_leds/screens/find_devices_screen.dart';
import 'package:rainbow_leds/screens/bluetooth_off_screen.dart';
// import 'package:rainbow_leds/bloc/blocs.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const MyHomePage());
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Padding(
          padding: EdgeInsets.only(top: statusBarHeight),
          child: StreamBuilder<BluetoothState>(
            stream: FlutterBlue.instance.state,
            initialData: BluetoothState.unknown,
            builder: (context, snapshot) {
              if (snapshot.data == BluetoothState.on) {
                return FindDevicesScreen();
              }
              // BlocProvider.of<BlDevicesBlocBloc>(context)
              //     .add(BlDevicesBlocEventScan());
              return const BluetoothOffScreen();
            },
          )),
    );
  }
}
