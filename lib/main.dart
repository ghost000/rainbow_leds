import 'package:flutter/material.dart';

import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(RainbowLedsApp());
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (context, snapshot) {
            if (snapshot.data == BluetoothState.on) {
              return Text("BluetoothState.on");
            }
              return Text("BluetoothState.off");
          },
        ));
  }
}
