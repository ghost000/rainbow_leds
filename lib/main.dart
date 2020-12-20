import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rainbow_leds/bloc/blocs.dart';
//import 'package:rainbow_leds/widgets/home_page_widget.dart';
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

class RainbowLedsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Rainbow leds app',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: BlocBuilder<AppStateBlocBloc, AppStateBlocState>(
            builder: (context, state) {
              if (state is AppStateBlocInitial) {
                //return MyHomePage(title: 'Rainbow leds app');
                return FindDevicesScreen();
              } else if (state is AppStateBlocGroup) {
                return FindDevicesScreen();
              } else if (state is AppStateBlocBluetoothOff) {
                return BluetoothOffScreen();
              } else if (state is AppStateBlocControl) {
                return ControlPanelScreen();
              }
              return CircularProgressIndicator();
            },
          ),
        ));
  }
}
