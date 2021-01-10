import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rainbow_leds/bloc/blocs.dart';
import 'package:rainbow_leds/widgets/find_devices_screen.dart';
import 'package:rainbow_leds/widgets/bluetooth_off_screen.dart';
import 'package:rainbow_leds/widgets/control_panel_widget.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BlDevicesBlocBloc>(
          create: (BuildContext context) => BlDevicesBlocBloc(),
        ),
        BlocProvider<AppStateBlocBloc>(
          create: (BuildContext context) => AppStateBlocBloc(),
        ),
      ],
      child: RainbowLedsApp(),
    ),
  );
}

class RainbowLedsApp extends StatefulWidget {
  @override
  _RainbowLedsApp createState() => _RainbowLedsApp();
}

class _RainbowLedsApp extends State<RainbowLedsApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rainbow leds app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => FindDevicesScreen(),
        '/BluetoothOffScreen': (context) => BluetoothOffScreen(),
        '/ControlPanelScreen': (context) => ControlPanelScreen(),
      },
      initialRoute: '/',
    );
  }
}
