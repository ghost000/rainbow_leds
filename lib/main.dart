import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/blocs.dart';
import 'screens/bluetooth_off_screen.dart';
import 'screens/control_panel_group_screen.dart';
import 'screens/control_panel_independent_and_group_screen.dart';
import 'screens/control_panel_independent_screen.dart';
import 'screens/find_devices_screen.dart';
import 'screens/scenario_screen.dart';
import 'package:flutter/services.dart';
//import 'package:google_fonts/google_fonts.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(
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
    ),
    blocObserver: SimpleBlocObserver(),
  );
}

class RainbowLedsApp extends StatefulWidget {
  @override
  _RainbowLedsApp createState() => _RainbowLedsApp();
}

class _RainbowLedsApp extends State<RainbowLedsApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return MaterialApp(
      title: 'just light',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          bottomAppBarColor: Colors.transparent,
          // textTheme: GoogleFonts.robotoTextTheme(
          //   Theme.of(context).textTheme,
          // ),
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
              color: Colors.orange,
              fontSize: 30,
              //fontStyle: GoogleFonts.s,
              //fontFamily: 'RaleWay'
            ),
            color: Colors.transparent,
          ),
          scaffoldBackgroundColor: Colors.green),
      routes: {
        '/': (context) => FindDevicesScreen(),
        '/BluetoothOffScreen': (context) =>
            BluetoothOffScreen(key: null, state: null),
        '/ControlPanelIndependentAndGroupScreen': (context) =>
            ControlPanelIndependentAndGroupScreen(),
        '/ControlPanelIndependentScreen': (context) =>
            ControlPanelIndependentScreen(),
        '/ControlPanelGroupScreen': (context) => ControlPanelGroupScreen(),
        '/ScenarioSetterScreen': (context) => ScenarioSetterScreen(),
      },
      initialRoute: '/',
    );
  }
}
