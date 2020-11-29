import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rainbow_leds/bloc/blocs.dart';
import 'package:rainbow_leds/widgets/home_page_widget.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(
    BlocProvider(
      create: (context) {
        return BlDevicesBlocBloc();
      },
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
      home: MyHomePage(title: 'Rainbow leds app'),
    );
  }
}
