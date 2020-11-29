import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rainbow_leds/bloc/blocs.dart';

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
              scanMode: ScanMode.lowPower, timeout: Duration(seconds: 4)),
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
                          final String device = scanResult.device.toString();
                          final String advertisementData =
                              scanResult.advertisementData.toString();
                          print("$device 1");
                          print("$advertisementData 2");
                          BlocProvider.of<BlDevicesBlocBloc>(context).add(
                              BlDevicesBlocEventAddToNotAssigned(
                                  LedState(data)));
                          print("$device 1");
                          print("$advertisementData 2");
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
                    scanMode: ScanMode.lowLatency,
                    timeout: Duration(seconds: 20)));
          }
        },
      ),
    );
  }
}
