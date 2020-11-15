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
  double statusBarHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top;

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
                return BluetoothOffScreen(state: snapshot.data);
              },
            )));
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class FindDevicesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find devices"),
      ),
      backgroundColor: Colors.lightBlue,
      body: RefreshIndicator(
          onRefresh: () => FlutterBlue.instance.startScan(
              scanMode: ScanMode.balanced, timeout: Duration(seconds: 4)),
          child: ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: <Widget>[
              StreamBuilder<List<ScanResult>>(
                  stream: FlutterBlue.instance.scanResults,
                  initialData: [],
                  builder: (context, snapshot) => Column(
                        children: snapshot.data.map((scanResult) {
                          final String data = scanResult.device.name.toString();
                          final String text = scanResult.device.id.toString();
                          final String text2 = scanResult.device.toString();
                          print("$data 1");
                          print("$text 2");
                          print("$text2 3");
                          if (data != null && data.isNotEmpty) {
                            return Text('Bluetooth Device is $data.');
                          } else {
                            return SizedBox.shrink();
                          }
                        }).toList(),
                      ))
            ],
          )),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: Icon(Icons.search),
                onPressed: () => FlutterBlue.instance.startScan(
                    scanMode: ScanMode.balanced,
                    timeout: Duration(seconds: 20)));
          }
        },
      ),
    );
  }
}
