import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'bloc/blocs.dart';
import 'screens/bluetooth_off_screen.dart';
import 'screens/control_panel_group_screen.dart';
import 'screens/control_panel_independent_and_group_screen.dart';
import 'screens/control_panel_independent_screen.dart';
import 'screens/find_devices_screen.dart';
import 'screens/scenario_screen.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<BlDevicesBlocBloc>(
            create: (context) => BlDevicesBlocBloc(),
          ),
          BlocProvider<AppStateBlocBloc>(
            create: (context) => AppStateBlocBloc(),
          ),
        ],
        child: const RainbowLedsApp(),
      ),
    ),
    blocObserver: SimpleBlocObserver(),
  );
}

class RainbowLedsApp extends StatefulWidget {
  const RainbowLedsApp({Key? key}) : super(key: key);

  @override
  _RainbowLedsApp createState() => _RainbowLedsApp();
}

class _RainbowLedsApp extends State<RainbowLedsApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return NeumorphicApp(
      title: 'just light',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const FindDevicesScreen(),
        '/BluetoothOffScreen': (context) => const BluetoothOffScreen(),
        '/ControlPanelIndependentAndGroupScreen': (context) =>
            const ControlPanelIndependentAndGroupScreen(),
        '/ControlPanelIndependentScreen': (context) =>
            const ControlPanelIndependentScreen(),
        '/ControlPanelGroupScreen': (context) =>
            const ControlPanelGroupScreen(),
        '/ScenarioSetterScreen': (context) => const ScenarioSetterScreen(),
      },
      initialRoute: '/',
    );
  }
}
