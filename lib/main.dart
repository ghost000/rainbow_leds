import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rainbow_leds/bloc/blocs.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rainbow_leds/widgets/home_page_widget.dart';
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
  //final _navigatorKey = GlobalKey<NavigatorState>();

  //NavigatorState get _navigator => _navigatorKey.currentState;
  @override
  Widget build(BuildContext context) {
    //listenFlutterBlue(context);
    //listenFlutterBlue(context);
    return MaterialApp(
      //navigatorKey: _navigatorKey,
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
      // builder: (context, child) {
      //   // return MyHomePage(title: 'Rainbow leds app');
      //   // return BlocListener<AppStateBlocBloc, AppStateBlocState>(
      //   //   cubit: BlocProvider.of<AppStateBlocBloc>(context),
      //   //   listener: (context, state) {
      //   //     if (state is AppStateBlocInitial) {
      //   //       //return MyHomePage(title: 'Rainbow leds app');
      //   //       Navigator.of(context).push(
      //   //         FindDevicesScreen.route(),
      //   //         //(route) => false,
      //   //       );
      //   //       //return FindDevicesScreen();
      //   //     } else if (state is AppStateBlocGroup) {
      //   //       //return FindDevicesScreen();

      //   //       Navigator.of(context).push(
      //   //         FindDevicesScreen.route(),
      //   //         //(route) => false,
      //   //       );
      //   //     } else if (state is AppStateBlocBluetoothOff) {
      //   //       //return BluetoothOffScreen();

      //   //       Navigator.of(context).push(
      //   //         BluetoothOffScreen.route(),
      //   //         // (route) => false,
      //   //       );
      //   //     } else if (state is AppStateBlocControl) {
      //   //       Navigator.of(context).push(ControlPanelScreen.route());
      //   //       // _navigator.pushAndRemoveUntil<void>(
      //   //       //   ControlPanelScreen.route(),
      //   //       //   (route) => false,
      //   //       // );
      //   //       //eturn ControlPanelScreen();
      //   //     }
      //   //     //return CircularProgressIndicator();
      //   //   },
      //   //   child: child,
      //   // );
      // },
      //onGenerateRoute: (settings) => FindDevicesScreen.route(),
      // initialRoute: "/home",
      // routes: {
      //   "/home": (context) => MyHomePage(),
      //   "/": (context) => FindDevicesScreen(),
      //   "/BluetoothOffScreen": (context) => BluetoothOffScreen(),
      //   "/ControlPanelScreen": (context) => ControlPanelScreen(),
      // },
      // home: BlocBuilder<AppStateBlocBloc, AppStateBlocState>(
      //   builder: (context, state) {
      //     if (state is AppStateBlocInitial) {
      //       //return MyHomePage(title: 'Rainbow leds app');
      //       return FindDevicesScreen();
      //     } else if (state is AppStateBlocGroup) {
      //       return FindDevicesScreen();
      //     } else if (state is AppStateBlocBluetoothOff) {
      //       return BluetoothOffScreen();
      //     } else if (state is AppStateBlocControl) {
      //       return ControlPanelScreen();
      //     }
      //     return CircularProgressIndicator();
      //   },
      // ),
    );
  }

  // listenFlutterBlue(BuildContext context) async {
  //   FlutterBlue.instance.state.listen((event) {
  //     if (event == BluetoothState.on) {
  //       BlocProvider.of<AppStateBlocBloc>(context).add(AppStateBlocEventGroup());
  //     } else {
  //       BlocProvider.of<AppStateBlocBloc>(context).add(AppStateBlocEventBluetoothOff());
  //     }
  //   });
  // }
}
